using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.Models
{
    public partial class DistanceResult
    {

        private static IList<DistanceResult> ProcessPair(IList<VendorTestResult> firstResults, IList<VendorTestResult> secondResults)
        {
            IList<DistanceResult> distanceResults = new List<DistanceResult>();
            foreach (var firstResult in firstResults)
            {
                VendorTestResult secondResult = (from e in secondResults
                                                 where e.TestItemId == firstResult.TestItemId
                                                 select e).SingleOrDefault();

                DistanceResult dr = new DistanceResult { FirstVendorTestResult = firstResult, SecondVendorTestResult = secondResult, Distance = (double)0 };

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

        private static IList<int[]> GetPairIterations(IList<int> idList)
        {
            IList<int[]> pairs = new List<int[]>();

            IList<int> secondList = idList.ToList();

            bool continueOuter = false;
            foreach (var firstId in idList)
            {
                if (continueOuter)
                {
                    continueOuter = false;
                    continue;
                }
                foreach (var secondId in secondList)
                {
                    if (firstId == secondId) continue;
                    foreach (int[] pair in pairs)
                    {
                        if (pair[0] == secondId && pair[1] == firstId)
                        {
                            continueOuter = true;
                            break;
                        }
                    }
                    pairs.Add(new int[] { firstId, secondId });
                }
            }

            return pairs;
        }

        public static IList<DistanceResult> ProcessDistances(IList<VendorTestResult> testResults)
        {
            List<DistanceResult> distanceResults = new List<DistanceResult>();

            // get iterations of paired vendor ids
            IList<int> vendorInts = (from v in testResults select v.VendorId).Distinct().ToList();
            IList<int[]> pairs = GetPairIterations(vendorInts);

            foreach (var pair in pairs)
            {
                IList<VendorTestResult> firstresults = (from e in testResults where e.VendorId == pair[0] select e).ToList();
                IList<VendorTestResult> secondResults = (from e in testResults where e.VendorId == pair[1] select e).ToList();
                IList<DistanceResult> pairResults = DistanceResult.ProcessPair(firstresults, secondResults);
                distanceResults.AddRange(pairResults);
            }

            return distanceResults;
        }


    }
}
