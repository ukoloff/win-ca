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
    var all = new List<string>();
    foreach(var crt in store.Certificates)
    {
      // all.Add(crt.ToString());
      all.Add(crt.Subject);
    }
    return all;
  }
}
