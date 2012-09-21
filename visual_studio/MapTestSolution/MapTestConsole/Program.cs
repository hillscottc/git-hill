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


namespace MapTestConsole
{
    class Program
    {
        static int NUM_TO_PROCESS = 2000;
        static int RESELLER_ID_MIN = 241;
        static int RESELLER_ID_MAX = 341;

        private static Models.MapTestDbEntities dbTest = new Models.MapTestDbEntities();

        // for vwMapTest which gets data where campid status in 2 (CampaignActive), 6(ContractActive), or 13(AdevertiserArrayActive)
        private static Models.Geneva3_ReportingEntities1 dbReporting = new Models.Geneva3_ReportingEntities1();

        public static ILog log = LogManager.GetLogger(typeof(Program));

        static void Main(string[] args)
        {
            log4net.Config.XmlConfigurator.Configure();

            Console.WindowWidth = 100;
            int count = 0;
            int errorCount = 0;

            Console.WriteLine("Processing. See details in log.");

            List<string> addr_list = new List<string>();

            var testAddresses = (from t in dbReporting.vwMapTests
                                 where t.ResellerID >= RESELLER_ID_MIN
                                 && t.ResellerID <= RESELLER_ID_MAX
                                select t).Distinct().Take(NUM_TO_PROCESS);

 
            foreach (Models.vwMapTest v in testAddresses)
            {
                count++;

                var mtr = new Models.MapTestResult { address = v.GetLocationString(), resellId = v.ResellerID };

                bool setOk = false;
                try
                {
                    mtr.SetResults();
                    setOk = true;
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.ToString());
                    log.Error(e.ToString());
                    errorCount++;
                }
                Console.Write("..." + count.ToString());
                log.Info("Count: " + count.ToString() + "\n" + mtr.ToString());

                // save to db
                if (setOk)
                {
                    try
                    {
                        dbTest.MapTestResults.Add(mtr);
                        dbTest.SaveChanges();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.ToString());
                        log.Error(e.ToString());
                        errorCount++;
                    }
                }
                Console.WriteLine("\n");
            }

            Console.WriteLine("\n\nError count: " + errorCount.ToString());
            // Console.WriteLine("\n\nDone. Closing....");
            Console.WriteLine("\n\nDone. Press any key to close.");
            Console.ReadKey();
        }

    }
}
