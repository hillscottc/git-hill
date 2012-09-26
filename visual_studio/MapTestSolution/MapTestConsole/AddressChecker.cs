using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using log4net;
using log4net.Config;
using Geneva3.G3GeoMap;
using System.Data.Entity;


namespace MapTestConsole
{
    public static class AddressChecker
    {
        private static ILog log = LogManager.GetLogger(typeof(AddressChecker));


        /// <summary>
        /// Read advertiser addresses from Geneva3_Reporting db. Query OpenSourceMaps with and without zip code.
        /// Calc distance between the two results. Store in local db for analysis.
        /// </summary>
        /// <param name="numToProcess"></param>
        /// <param name="resellerIdMin"></param>
        /// <param name="resellerIdMax"></param>
        /// <returns></returns>
        //public static string ProcessRecords(int numToProcess, int resellerIdMin, int resellerIdMax)
        //{
        //    var dbTest = new Models.ResultModelContainer();
        //    var dbReporting = new Models.Geneva3_ReportingEntities1();

        //    int count = 0;
        //    int errorCount = 0;

        //    Console.WriteLine(String.Format("Process {0} records with resellerId in range {1} to {2}.", numToProcess, resellerIdMin, resellerIdMax));
        //    Console.WriteLine("Beginning.....see details in log file.");

        //    List<string> addr_list = new List<string>();

        //    var testAddresses = (from t in dbReporting.vwMapTests
        //                         where t.ResellerID >= resellerIdMin
        //                         && t.ResellerID <= resellerIdMax
        //                         select t).Distinct().Take(numToProcess);


        //    foreach (Models.vwMapTest v in testAddresses)
        //    {
        //        count++;

        //        //var mtr = new Models.MapTestResult { address = v.GetLocationString(), resellId = v.ResellerID };
        //        Models.ITestItem testItem = new Models.TestItem { Address = GeoMapUtil.GetLocationString(v.City, v.Region, v.PostalCode), ResellerId = v.ResellerID };

        //        var testResultList = new List<Models.TestResult>();

        //        bool setOk = false;
        //        try
        //        {
        //            Models.ITestResult testResult;
        //            Models.ITestResult testResult = new Models.TestResult { };
        //            mtr.SetResults();
        //            setOk = true;
        //        }
        //        catch (Exception e)
        //        {
        //            Console.WriteLine(e.ToString());
        //            log.Error(e.ToString());
        //            errorCount++;
        //        }
        //        Console.Write("..." + count.ToString());
        //        log.Info("Count: " + count.ToString() + "\n" + mtr.ToString());

        //        // save to db
        //        if (setOk)
        //        {
        //            try
        //            {
        //                dbTest.MapTestResults.Add(mtr);
        //                dbTest.SaveChanges();
        //            }
        //            catch (Exception e)
        //            {
        //                Console.WriteLine(e.ToString());
        //                log.Error(e.ToString());
        //                errorCount++;
        //            }
        //        }
        //        Console.WriteLine("\n");
        //    }

        //    string msg = String.Format("Processed {0} records with {1} errors.", count, errorCount);

        //    return msg;

        //}
    }
}
