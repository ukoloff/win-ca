#include <Windows.h>

#include <Wincrypt.h>

#include <napi.h>

class Crypt32 : public Napi::ObjectWrap<Crypt32> {
 public:
  Crypt32(const Napi::CallbackInfo& info);

  static Napi::Object Init(Napi::Env env, Napi::Object exports);

 private:
  HCERTSTORE hStore;
  PCCERT_CONTEXT pCtx = nullptr;
  static Napi::FunctionReference constructor;

  Napi::Value done(const Napi::CallbackInfo&);
};

// Implementation

Napi::FunctionReference Crypt32::constructor;

Crypt32::Crypt32(const Napi::CallbackInfo& info)
    : Napi::ObjectWrap<Crypt32>(info),
      hStore(CertOpenSystemStoreA(0, "ROOT")) {}

Napi::Value Crypt32::done(const Napi::CallbackInfo& info) {
  CertCloseStore(hStore, 0);
  return info.Env().Undefined();
}

Napi::Object Crypt32::Init(Napi::Env env, Napi::Object exports) {
  Napi::HandleScope scope(env);

  Napi::Function func =
      DefineClass(env, "Crypt32", {InstanceMethod("done", &Crypt32::done)});

  constructor = Napi::Persistent(func);
  constructor.SuppressDestruct();

  exports.Set("Crypt32", func);
  return exports;
}

static Napi::Object Init(Napi::Env env, Napi::Object exports) {
  return Crypt32::Init(env, exports);
}

NODE_API_MODULE(addon, Init)
