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

        private static ResultModelContainer dbTest = new ResultModelContainer();
        private static Geneva3_ReportingEntities1 dbReporting = new Geneva3_ReportingEntities1();

        /// <summary>
        /// Read advertiser addresses from Geneva3_Reporting db. Query OpenSourceMaps with and without zip code.
        /// Calc distance between the two results. Store in local db for analysis.
        /// </summary>
        /// <param name="numToProcess"></param>
        /// <param name="resellerIdMin"></param>
        /// <param name="resellerIdMax"></param>
        /// <returns></returns>
        public static string ProcessRecords(int numToProcess, int resellerIdMin, int resellerIdMax)
        {

            Console.WriteLine(String.Format("Process {0} records with resellerId in range {1} to {2}.", numToProcess, resellerIdMin, resellerIdMax));
            Console.WriteLine("Beginning.....see details in log file.");


            List<Models.vwMapTest> testAddresses = (from t in dbReporting.vwMapTests
                                 where t.ResellerID >= resellerIdMin
                                 && t.ResellerID <= resellerIdMax
                                 select t).Distinct().Take(numToProcess).ToList();
            
            return ProcessRecords(testAddresses);
 
        }

        public static string ProcessRecords(List<Models.vwMapTest> testAddresses)
        {
            var dbTest = new Models.ResultModelContainer();
            var dbReporting = new Models.Geneva3_ReportingEntities1();

            int count = 0;
            int errorCount = 0;

            foreach (Models.vwMapTest mt in testAddresses)
            {
                count++;

                //var mtr = new Models.MapTestResult { address = v.GetLocationString(), resellId = v.ResellerID };
                var testItem = new Models.TestItem
                {
                    Address = GeoMapUtil.GetLocationString(mt.City, mt.Region, mt.PostalCode),
                    ResellerId = mt.ResellerID
                };

                dbTest.TestItems.Add(testItem);
                dbTest.SaveChanges();

                var vendor = (from v in dbTest.Vendors where v.Name.Equals("Google") select v).SingleOrDefault();

                var testResult = new Models.VendorTestResult();
                testResult.SetResults(testItem, vendor);

                dbTest.VendorTestResults.Add(testResult);
                dbTest.SaveChanges();


            }

            //bool setOk = false;
            //try
            //{
            //    Models.ITestResult testResult;
            //    Models.ITestResult testResult = new Models.TestResult { };
            //    mtr.SetResults();
            //    setOk = true;
            //}
            //catch (Exception e)
            //{
            //    Console.WriteLine(e.ToString());
            //    log.Error(e.ToString());
            //    errorCount++;
            //}
            //Console.Write("..." + count.ToString());
            //log.Info("Count: " + count.ToString() + "\n" + mtr.ToString());

            //// save to db
            //if (setOk)
            //{
            //    try
            //    {
            //        dbTest.MapTestResults.Add(mtr);
            //        dbTest.SaveChanges();
            //    }
            //    catch (Exception e)
            //    {
            //        Console.WriteLine(e.ToString());
            //        log.Error(e.ToString());
            //        errorCount++;
            //    }
            //}
            //Console.WriteLine("\n");
            string msg = String.Format("Processed {0} records with {1} errors.", count, errorCount);

            return msg;

        }

    }
}
