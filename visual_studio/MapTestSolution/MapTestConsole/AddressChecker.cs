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


        public static IList<VendorTestResult> ProcessAddresses(IList<TestItem> testItems)
        {
            IList<VendorTestResult> testResults = new List<VendorTestResult>();

            int count = 0;

            foreach (TestItem testItem in testItems)
            {
                count++;

                IList<Vendor> vendorList;
                using (var dbTest = new ResultModelContainer())
                {
                    vendorList = (from v in dbTest.Vendors select v).ToList();
                }

                foreach (Vendor vendor in vendorList)
                {
                    try
                    {
                        //VendorTestResult testResult = new VendorTestResult(testItem.Id, vendor.Id);
                        VendorTestResult testResult = new VendorTestResult(testItem, vendor);
                        testResult.ProcessGeoCoding();
                        testResults.Add(testResult);
                        log.Info(String.Format("Address count: {0}, {1}", count.ToString(), testResult.ToString()));
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.ToString());
                        log.Error(String.Format("Failed tested number {0} for {1}\n{2}", count, testItem.ToString(), e.ToString()));
                    }

                }

            }

            return testResults;
        }


        public static IList<DistanceResult> ProcessDistances(IList<VendorTestResult> testResults)
        {
            IList<DistanceResult> distanceResults = new List<DistanceResult>();

            int googleVendorId = Vendor.GetIdByName("Google");
            int osmVendorId = Vendor.GetIdByName("OpenStreetMap");

            IList<VendorTestResult> googleResults = (from e in testResults where e.VendorId == googleVendorId select e).ToList();
            IList<VendorTestResult> osmResults = (from e in testResults where e.VendorId == osmVendorId select e).ToList();

            foreach (var gResult in googleResults)
            {
                VendorTestResult osmResult = (from e in osmResults
                                              where e.TestItemId == gResult.TestItemId
                                              select e).SingleOrDefault();

                DistanceResult dr = new DistanceResult { FirstVendorTestResult = gResult, SecondVendorTestResult = osmResult, Distance = (double) 0 };



                if (dr.FirstVendorTestResult.Latitude != VendorTestResult.NullValue && dr.SecondVendorTestResult.Latitude != VendorTestResult.NullValue)
                {
                    float f = (float)GeoMapUtil.distance((double)dr.FirstVendorTestResult.Latitude,
                                                (double)dr.FirstVendorTestResult.Longitude,
                                                (double)dr.SecondVendorTestResult.Latitude,
                                                (double)dr.SecondVendorTestResult.Longitude, 'M');

                    if (!float.IsNaN(f))
                    {
                        dr.Distance = (float)Math.Round(f, 2);
                    }
                }

                distanceResults.Add(dr);
            }

            return distanceResults;
        }


    }

}
