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

            log.Info(String.Format("Process {0} records with resellerId in range {1} to {2}.", numToProcess, resellerIdMin, resellerIdMax));
            //Console.WriteLine("Beginning.....see details in log file.");

            IList<vwMapTest> genevaAddresses;

            try
            {
                using (Geneva3_ReportingEntities1 dbReporting = new Geneva3_ReportingEntities1())
                {
                    genevaAddresses = (from t in dbReporting.vwMapTests
                                       where t.ResellerID >= resellerIdMin
                                       && t.ResellerID <= resellerIdMax
                                       select t).Distinct().Take(numToProcess).ToList();
                }
            }
            catch (Exception e)
            {
                log.Error(e);
                throw;
            }

            return genevaAddresses;

        }


    }

}
