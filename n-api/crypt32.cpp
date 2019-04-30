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
  Napi::Value none(const Napi::CallbackInfo&);

  const uint8_t* begin() const { return pCtx->pbCertEncoded; }
  const uint8_t* end() const { return begin() + pCtx->cbCertEncoded; }

  friend Napi::Object crypt32init(Napi::Env, Napi::Object);
  friend Napi::Object crypt32exports(const Napi::CallbackInfo&);
};

// Implementation

Napi::FunctionReference Crypt32::constructor;

Crypt32::Crypt32(const Napi::CallbackInfo& info)
    : Napi::ObjectWrap<Crypt32>(info), hStore(openStore(info)) {}

HCERTSTORE Crypt32::openStore(const Napi::CallbackInfo& info) {
  return CertOpenSystemStoreA(
      0, info.Length() > 0 && info[0].IsString()
             ? info[0].As<Napi::String>().Utf8Value().c_str()
             : "ROOT");
}

Napi::Value Crypt32::next(const Napi::CallbackInfo& info) {
  if (!hStore) return done(info);
  return (pCtx = CertEnumCertificatesInStore(hStore, pCtx))
             ? Napi::Buffer<uint8_t>::Copy(info.Env(), begin(),
                                           pCtx->cbCertEncoded)
             : done(info);
}

Napi::Value Crypt32::done(const Napi::CallbackInfo& info) {
  if (hStore) CertCloseStore(hStore, 0);
  hStore = 0;
  return info.Env().Undefined();
}

Napi::Value Crypt32::none(const Napi::CallbackInfo& info) {
  return Napi::Boolean::New(info.Env(), !hStore);
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

  Crypt32::constructor = Napi::Persistent(Crypt32::DefineClass(
      env, "Crypt32",
      {
          Crypt32::InstanceMethod("done", &Crypt32::done),
          Crypt32::InstanceMethod("next", &Crypt32::next),
          //  Crypt32::InstanceMethod("none", &Crypt32::none),
      }));
  Crypt32::constructor.SuppressDestruct();
  return Napi::Function::New(env, crypt32exports, "Crypt32");
}

NODE_API_MODULE(crypt32, crypt32init)
