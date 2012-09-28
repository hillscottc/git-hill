using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Web;
using System.Xml;
using System.IO;
using log4net;
using log4net.Config;
using Geneva3.G3GeoMap;
using MapTestConsole.Models;



namespace MapTestConsole
{
    class Program
    {
        private static ILog log = LogManager.GetLogger(typeof(Program));


        static void Main(string[] args)
        {
            log4net.Config.XmlConfigurator.Configure();
            log.Info("Begin.");

            var addressList = new List<vwMapTest>
            {
                new Models.vwMapTest { City="Inglewood", Region="CA", PostalCode="90305" },
                new Models.vwMapTest { City="Uxbridge", Region="MA", PostalCode="01569" },
            };

            //var addressList = AddressChecker.GetGenevaAddresses(2, 241, 241);

            using (var dbTest = new ResultModelContainer())
            {
                // get testitems from raw addresses
                IList<TestItem> testItemList = TestItem.GetTestItems(addressList);
                dbTest.SaveTestItems(testItemList);
                log.Info(String.Format("Processed {0} addresses.", testItemList.Count));

                // get vendor results from test items
                IList<VendorTestResult> vendorResultList = AddressChecker.ProcessAddresses(testItemList);
                dbTest.SaveVendorTestResults(vendorResultList);
                log.Info(String.Format("Processed {0} vendor results.", vendorResultList.Count));

                // get distance results from vendor test pairs.
                IList<DistanceResult> distanceResultList = AddressChecker.ProcessDistances(vendorResultList);
                dbTest.SaveDistanceResults(distanceResultList);
                log.Info(String.Format("Processed {0} distances.", distanceResultList.Count));
            }
            //TestGoogleMaps();

            log.Info("Done");

            //Console.WriteLine("\n\nDone. Press any key to close.");
            //Console.ReadKey();

        }


    }
}
