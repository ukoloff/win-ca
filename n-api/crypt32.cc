#include <Windows.h>

#include <Wincrypt.h>

#include <napi.h>

class Crypt32 : public Napi::ObjectWrap<Crypt32> {
 public:
  Crypt32(const Napi::CallbackInfo& info);

 private:
  HCERTSTORE hStore;
  PCCERT_CONTEXT pCtx = nullptr;
  static Napi::FunctionReference constructor;

  static HCERTSTORE openStore(const Napi::CallbackInfo&);

  Napi::Value next(const Napi::CallbackInfo&);
  Napi::Value done(const Napi::CallbackInfo&);

  char* begin() const { return (char*)pCtx->pbCertEncoded; }
  char* end() const { return begin() + pCtx->cbCertEncoded; }

  friend Napi::Object crypt32nit(Napi::Env, Napi::Object);
  friend Napi::Object crypt32exports(const Napi::CallbackInfo&);
};

// Implementation

Napi::FunctionReference Crypt32::constructor;

Crypt32::Crypt32(const Napi::CallbackInfo& info)
    : Napi::ObjectWrap<Crypt32>(info), hStore(openStore(info)) {}

HCERTSTORE Crypt32::openStore(const Napi::CallbackInfo&) {
  return CertOpenSystemStoreA(0, "ROOT");
}

Napi::Value Crypt32::next(const Napi::CallbackInfo& info) {
  pCtx = CertEnumCertificatesInStore(hStore, pCtx);
  if (!pCtx) return info.Env().Undefined();
  auto pem = Napi::Buffer<uint8_t>::New(info.Env(), pCtx->cbCertEncoded);
  std::copy(begin(), end(), pem.Data());
  return pem;
}

Napi::Value Crypt32::done(const Napi::CallbackInfo& info) {
  CertCloseStore(hStore, 0);
  return info.Env().Undefined();
}

Napi::Object crypt32exports(const Napi::CallbackInfo& info) {
  Napi::EscapableHandleScope scope(info.Env());
  std::vector<napi_value> args(info.Length());
  for (size_t i = 0; i < args.size(); ++i) {
    args[i] = info[i];
  }
  Napi::Object obj = Crypt32::constructor.New(args);
  return scope.Escape(napi_value(obj)).ToObject();
}

Napi::Object crypt32init(Napi::Env env, Napi::Object) {
  Napi::HandleScope scope(env);

  Crypt32::constructor = Napi::Persistent(
      Crypt32::DefineClass(env, "Crypt32",
                           {
                               Crypt32::InstanceMethod("done", &Crypt32::done),
                               Crypt32::InstanceMethod("next", &Crypt32::next),
                           }));
  Crypt32::constructor.SuppressDestruct();
  return Napi::Function::New(env, crypt32exports, "Crypt32");
}

NODE_API_MODULE(crypt32, crypt32init)
