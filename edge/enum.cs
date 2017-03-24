using System.Threading.Tasks;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;

public class Startup
{
  public async Task<object> Invoke(object input)
  {
    var store = new X509Store(StoreName.Root, StoreLocation.CurrentUser);
    store.Open(OpenFlags.OpenExistingOnly);

    var all = new List<byte[]>();
    foreach(var crt in store.Certificates)
    {
      all.Add(crt.GetRawCertData());
    }
    return all;
  }
}
