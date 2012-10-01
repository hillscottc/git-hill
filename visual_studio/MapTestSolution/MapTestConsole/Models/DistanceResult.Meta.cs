using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using log4net;
using log4net.Config;

namespace MapTestConsole.Models
{
    public partial class DistanceResult
    {
        private static ILog log = LogManager.GetLogger(typeof(DistanceResult));

        // Default Distance defined as -1.
        public DistanceResult()
            : base()
        {
            Distance = -1;
        }

        private static DistanceResult ProcessPair(VendorTestResult[] pair)
        {

            DistanceResult dr = new DistanceResult
            {
                FirstVendorTestResult = pair[0],
                SecondVendorTestResult = pair[1]
            };

            try
            {
                var firstCoord = new GeoCoding.GeoCoordinates
                {
                    Latitude = dr.FirstVendorTestResult.Latitude,
                    Longitude = dr.FirstVendorTestResult.Longitude
                };

                var secondCoord = new GeoCoding.GeoCoordinates
                {
                    Latitude = dr.SecondVendorTestResult.Latitude,
                    Longitude = dr.SecondVendorTestResult.Longitude
                };

                double distance = firstCoord.GetDistanceTo(secondCoord);

                if (!double.IsNaN(distance))
                {
                    dr.Distance = (float)Math.Round(distance, 2);
                }

                log.Info(dr);
            }
            catch (Exception e)
            {
                log.Error(String.Format("Unable to calc distance. {0} ", e.Message));
            }

            return dr;
        }

        public static IList<DistanceResult> ProcessDistances(IList<VendorTestResult> testResults)
        {
            List<DistanceResult> distanceResults = new List<DistanceResult>();

            // get combos of paired vendor ids
            int[] vendorInts = (from v in testResults select v.VendorId).Distinct().ToArray<int>();
            IEnumerable<int[]> pairs = ComboUtil.GetCombinations(vendorInts, 2);

            IList<VendorTestResult[]> vendorResultPairs = new List<VendorTestResult[]>();
            foreach (int[] pair in pairs)
            {
                VendorTestResult[] vendorResultPair = new VendorTestResult[2];
                try
                {
                    vendorResultPair[0] = (from e in testResults where e.VendorId == pair[0] select e).First();
                    vendorResultPair[1] = (from e in testResults where e.VendorId == pair[1] select e).First();
                    vendorResultPairs.Add(vendorResultPair);
                }
                catch (Exception)
                {
                    log.Warn("Problem getting pairs for distance calc.");
                }

            }

            if (vendorResultPairs.Count > 0)
            {
                foreach (VendorTestResult[] pair in vendorResultPairs)
                {
                    DistanceResult dr = DistanceResult.ProcessPair(pair);
                    if (dr != null)
                    {
                        distanceResults.Add(DistanceResult.ProcessPair(pair));
                    }
                }
            }

            return distanceResults;
        }

        public override string ToString()
        {
            return String.Format("TestItem {0}...distance between results from vendors {1} and {2} is {3}", FirstVendorTestResult.TestItemId, FirstVendorTestResult.VendorId, SecondVendorTestResult.VendorId, Distance);
        }
    }
}
