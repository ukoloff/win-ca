#include <Windows.h>
#include <stdio.h>

#include <Wincrypt.h>

static void dumpStore(const char*);

int main(int argc, char* argv[]) {
  if (argc > 1) {
    for (int i = 1; i < argc; ++i) {
      dumpStore(argv[i]);
    }
  } else {
    dumpStore("ROOT");
  }
  return 0;
}

static void dumpStore(const char* title) {
  HCERTSTORE hStore = CertOpenSystemStoreA(0, title);
  for (PCCERT_CONTEXT pCtx = 0;
       pCtx = CertEnumCertificatesInStore(hStore, pCtx);) {
    DWORD i;
    BYTE* p;
    for (i = pCtx->cbCertEncoded, p = pCtx->pbCertEncoded; i--; ++p) {
      BYTE c = *p;
      for (int i = 0; i < 2; ++i, c <<= 4) {
        BYTE nibble = c >> 4;
        putchar(nibble < 10 ? nibble + '0' : nibble + 'a' - 10);
      }
    }
    puts("");
  }
  CertCloseStore(hStore, 0);
}
