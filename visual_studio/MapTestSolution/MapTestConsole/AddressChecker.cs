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
        private static ILog log;
        private static DbContext dbTest;

        static AddressChecker()
        {
            log = LogManager.GetLogger(typeof(AddressChecker));
            dbTest = new Models.ResultModelContainer();
        }

        /// <summary>
        /// contains view vwMapTest, which has data where campid status is in 2 (CampaignActive), 6(ContractActive), or 13(AdevertiserArrayActive).
        /// </summary>
        private static Models.Geneva3_ReportingEntities1 dbReporting = new Models.Geneva3_ReportingEntities1();


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

        //        var mtr = new Models.MapTestResult { address = v.GetLocationString(), resellId = v.ResellerID };

        //        bool setOk = false;
        //        try
        //        {
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
