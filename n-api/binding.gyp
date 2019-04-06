{
  "targets": [
    {
      "target_name": "crypt32",
      "cflags!": [
        "-fno-exceptions"
      ],
      "cflags_cc!": [
        "-fno-exceptions"
      ],
      "sources": [
        "crypt32.cpp"
      ],
      "include_dirs": [
        "<!@(node -p \"require('node-addon-api').include\")"
      ],
      "defines": [
        "NAPI_DISABLE_CPP_EXCEPTIONS"
      ],
      "link_settings": {
        "libraries": ["-lcrypt32"]
      }
    },
    {
      "target_name": "roots",
      "type": "executable",
      "sources": [
        "roots.c"
      ],
      "link_settings": {
        "libraries": ["-lcrypt32"]
      }
    }
  ]
}
