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

        private static IList<DistanceResult> ProcessPair(IList<VendorTestResult> firstResults, IList<VendorTestResult> secondResults)
        {
            IList<DistanceResult> distanceResults = new List<DistanceResult>();
            foreach (var firstResult in firstResults)
            {
                VendorTestResult secondResult = (from e in secondResults
                                                 where e.TestItemId == firstResult.TestItemId
                                                 select e).SingleOrDefault();

                DistanceResult dr = new DistanceResult { FirstVendorTestResult = firstResult, SecondVendorTestResult = secondResult, Distance = (double)-1 };

                if (dr.FirstVendorTestResult.Latitude != GeoMapUtil.LatLngNullValue && dr.SecondVendorTestResult.Latitude != GeoMapUtil.LatLngNullValue)
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
                }

                distanceResults.Add(dr);
                log.Info(dr);
            }
            return distanceResults;
        }

        public static IList<DistanceResult> ProcessDistances(IList<VendorTestResult> testResults)
        {
            List<DistanceResult> distanceResults = new List<DistanceResult>();

            // get combos of paired vendor ids
            int[] vendorInts = (from v in testResults select v.VendorId).Distinct().ToArray<int>();
            IEnumerable<int[]> pairs = ComboUtil.GetCombinations(vendorInts, 2);

            foreach (var pair in pairs)
            {
                IList<VendorTestResult> firstresults = (from e in testResults where e.VendorId == pair[0] select e).ToList();
                IList<VendorTestResult> secondResults = (from e in testResults where e.VendorId == pair[1] select e).ToList();
                IList<DistanceResult> pairResults = DistanceResult.ProcessPair(firstresults, secondResults);
                distanceResults.AddRange(pairResults);
            }

            return distanceResults;
        }

        public override string ToString()
        {
            return String.Format("{0}; {1} vs {2}; Distance:{3}", FirstVendorTestResult.TestItem.Address, FirstVendorTestResult.Vendor.Name, SecondVendorTestResult.Vendor.Name, Distance);
        }
    }
}
