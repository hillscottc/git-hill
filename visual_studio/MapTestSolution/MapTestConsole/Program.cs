﻿using System;
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
using Geneva3.G3GeoMap;
using MapTestConsole.Models;



namespace MapTestConsole
{
    class Program
    {
        private static ILog log = LogManager.GetLogger(typeof(Program));



        private static List<Vendor> vendorList = new List<Vendor> 
        {
            Vendor.GetByName("OpenStreetMaps"), 
            Vendor.GetByName("MapQuest") 
        };

        private const bool USE_SAMPLE_ADDRESSES = false;

        private const int RESULT_COUNT = 500;
        private const int RESELLER_ID_MIN = 241;
        private const int RESELLER_ID_MAX = 300;

        private static IList<vwMapTest> sampleAddressList = new List<vwMapTest>
        {
            new Models.vwMapTest { City="Inglewood", Region="CA", PostalCode="90305" },
            new Models.vwMapTest { City="Uxbridge", Region="MA", PostalCode="01569" },
            new Models.vwMapTest { City="Santurce", Region="PR", PostalCode="00910" },
        };


        static void Main(string[] args)
        {

            log4net.Config.XmlConfigurator.Configure();
            log.Info("Begin.");

            //var addressList = AddressChecker.GetGenevaAddresses(100, 241, 300);

            using (var dbTest = new ResultModelContainer())
            {
                IList<TestItem> testItemList = null;
                IList<VendorTestResult> vendorResultList = null;
                IList<DistanceResult> distanceResultList = null;

                IList<vwMapTest> addressList;
                if (USE_SAMPLE_ADDRESSES)
                    addressList = sampleAddressList;
                else
                    addressList = AddressChecker.GetGenevaAddresses(RESULT_COUNT, RESELLER_ID_MIN, RESELLER_ID_MAX);
                
                // create testitems from raw addresses
                testItemList = TestItem.GetTestItems(addressList);
                dbTest.SaveTestItems(testItemList);
                log.Info(String.Format("Created {0} testItems from address list, saved to database.", testItemList.Count));

                // TODO: add an Active field in db to vendors table so it will know which to use?
                
                log.Info("Using vendors " + string.Join(",", vendorList.Select(e => e.Name).ToArray()));

                if (testItemList != null)
                {
                    vendorResultList = VendorTestResult.GetResultsForVendors(testItemList, vendorList);
                    log.Info(String.Format("Processed {0} vendor results.", vendorResultList.Count));
                }

                //if (vendorResultList != null)
                //{
                //    // get distance results from vendor test pairs.
                //    distanceResultList = DistanceResult.ProcessDistances(vendorResultList);
                //    dbTest.SaveDistanceResults(distanceResultList);
                //    log.Info(String.Format("Processed {0} distances, saved to database.", distanceResultList.Count));
                //}
            }

            log.Info("Done");

            //Console.WriteLine("\n\nDone. Press any key to close.");
            //Console.ReadKey();

        }


    }
}
