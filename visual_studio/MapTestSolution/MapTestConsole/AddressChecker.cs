using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using log4net;
using log4net.Config;
using Geneva3.G3GeoMap;
using System.Data.Entity;
using MapTestConsole.Models;


namespace MapTestConsole
{
    public static class AddressChecker
    {
        //static AddressChecker()
        //{
        //    log4net.Config.XmlConfigurator.Configure();
        //}
        private static ILog log = LogManager.GetLogger(typeof(AddressChecker));

        public static IList<vwMapTest> GetGenevaAddresses(int numToProcess, int resellerIdMin, int resellerIdMax)
        {

            Console.WriteLine(String.Format("Process {0} records with resellerId in range {1} to {2}.", numToProcess, resellerIdMin, resellerIdMax));
            Console.WriteLine("Beginning.....see details in log file.");

            IList<vwMapTest> genevaAddresses;

            using (Geneva3_ReportingEntities1 dbReporting = new Geneva3_ReportingEntities1())
            {
                genevaAddresses = (from t in dbReporting.vwMapTests
                                   where t.ResellerID >= resellerIdMin
                                   && t.ResellerID <= resellerIdMax
                                   select t).Distinct().Take(numToProcess).ToList();
            }

            return genevaAddresses;

        }

        // use the new one below.....
        //public static IList<DistanceResult> ProcessDistances(IList<VendorTestResult> testResults)
        //{
        //    List<DistanceResult> distanceResults = new List<DistanceResult>();

        //    int googleVendorId = Vendor.GetIdByName("Google");
        //    int osmVendorId = Vendor.GetIdByName("OpenStreetMap");
        //    int osmNoZipVendorId = Vendor.GetIdByName("OSMNoZip");

        //    IList<VendorTestResult> googleResults = (from e in testResults where e.VendorId == googleVendorId select e).ToList();
        //    IList<VendorTestResult> osmResults = (from e in testResults where e.VendorId == osmVendorId select e).ToList();
        //    IList<VendorTestResult> osmNoZipResults = (from e in testResults where e.VendorId == osmNoZipVendorId select e).ToList();

        //    IList<DistanceResult> pairResults;

        //    pairResults = DistanceResult.ProcessPair(googleResults, osmResults);
        //    distanceResults.AddRange(pairResults);

        //    pairResults = DistanceResult.ProcessPair(googleResults, osmNoZipResults);
        //    distanceResults.AddRange(pairResults);

        //    pairResults = DistanceResult.ProcessPair(osmResults, osmNoZipResults);
        //    distanceResults.AddRange(pairResults);

        //    return distanceResults;
        //}





    }

}
