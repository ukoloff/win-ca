#include <Windows.h>

#include <Wincrypt.h>

#include <napi.h>

class Crypt32 : public Napi::ObjectWrap<Crypt32> {
 public:
  Crypt32(const Napi::CallbackInfo& info);

  static void Init(Napi::Env env);
  static Napi::Object New(Napi::Env env);

 private:
  HCERTSTORE hStore;
  PCCERT_CONTEXT pCtx = nullptr;
  static Napi::FunctionReference constructor;

  Napi::Value next(const Napi::CallbackInfo&);
  Napi::Value done(const Napi::CallbackInfo&);

  char* begin() const { return (char*)pCtx->pbCertEncoded; }
  char* end() const { return begin() + pCtx->cbCertEncoded; }
};

// Implementation

Napi::FunctionReference Crypt32::constructor;

Crypt32::Crypt32(const Napi::CallbackInfo& info)
    : Napi::ObjectWrap<Crypt32>(info),
      hStore(CertOpenSystemStoreA(0, "ROOT")) {}

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

void Crypt32::Init(Napi::Env env) {
  Napi::HandleScope scope(env);

  Napi::Function func = DefineClass(env, "Crypt32",
                                    {
                                        InstanceMethod("done", &Crypt32::done),
                                        InstanceMethod("next", &Crypt32::next),
                                    });

  constructor = Napi::Persistent(func);
  constructor.SuppressDestruct();
}

Napi::Object Crypt32::New(Napi::Env env) {
  Napi::EscapableHandleScope scope(env);
  Napi::Object obj = constructor.New({});
  return scope.Escape(napi_value(obj)).ToObject();
}

static Napi::Object CreateCrypt32(const Napi::CallbackInfo& info) {
  return Crypt32::New(info.Env());
}

static Napi::Object Init(Napi::Env env, Napi::Object) {
  Crypt32::Init(env);
  return Napi::Function::New(env, CreateCrypt32, "Crypt32");
}

NODE_API_MODULE(crypt32, Init)
