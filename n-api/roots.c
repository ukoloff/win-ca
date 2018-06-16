#include <Windows.h>
#include <stdio.h>

#include <Wincrypt.h>

int main() {
  HCERTSTORE hStore = CertOpenSystemStoreA(0, "ROOT");
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
  return 0;
}
