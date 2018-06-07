#include <napi.h>
#include <numeric>

class My : public Napi::ObjectWrap<My> {
 public:
  My(const Napi::CallbackInfo& info);

  static void Init(Napi::Env env);
  static Napi::Object New(Napi::Env env);

 private:
  static Napi::FunctionReference constructor;

  Napi::Value get(const Napi::CallbackInfo&);
};

Napi::FunctionReference My::constructor;

My::My(const Napi::CallbackInfo& info) : Napi::ObjectWrap<My>(info) {}

Napi::Value My::get(const Napi::CallbackInfo& info) {
  auto pem = Napi::Buffer<uint8_t>::New(info.Env(), 108);
  auto ptr = pem.Data();
  std::iota(ptr, ptr + 108, 7);
  return pem;
}

void My::Init(Napi::Env env) {
  Napi::HandleScope scope(env);

  Napi::Function func = DefineClass(env, "My",
                                    {
                                        InstanceMethod("get", &My::get),
                                    });

  constructor = Napi::Persistent(func);
  constructor.SuppressDestruct();
}

Napi::Object My::New(Napi::Env env) {
  Napi::EscapableHandleScope scope(env);
  Napi::Object obj = constructor.New({});
  return scope.Escape(napi_value(obj)).ToObject();
}

static Napi::Object CreateMy(const Napi::CallbackInfo& info) {
  return My::New(info.Env());
}

static Napi::Object Init(Napi::Env env, Napi::Object) {
  My::Init(env);
  return Napi::Function::New(env, CreateMy, "CreateMy");
}

NODE_API_MODULE(my, Init)