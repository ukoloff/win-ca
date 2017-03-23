using System.Threading.Tasks;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;

public class Startup
{
  public async Task<object> Invoke(object input)
  {
    var store = new X509Store(StoreName.Root, StoreLocation.CurrentUser);
    store.Open(OpenFlags.OpenExistingOnly);

    System.Console.WriteLine("Version: " + System.Environment.Version.ToString());
    System.Console.Beep();
    List<string> all = new List<string>();
    foreach(X509Certificate2 crt in store.Certificates)
    {
      // all.Add(crt.ToString());
      all.Add(crt.Subject);
    }
    return all.ToArray();
  }
}
