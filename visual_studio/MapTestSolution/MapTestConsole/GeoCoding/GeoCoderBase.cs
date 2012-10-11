using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Data.Entity;
using log4net;
using MapTestConsole.Models;

namespace MapTestConsole.GeoCoding
{
    public abstract class GeoCoderBase : IGeoCoder
    {

        private static ILog log = LogManager.GetLogger(typeof(GeoCoderBase));

        public virtual GeoCodingProvider Provider
        {
            get { throw new NotImplementedException(); }
        }

        public virtual Uri UriRoot
        {
            get { throw new NotImplementedException(); }
        }

        protected virtual Uri GetQueryUri(string address)
        {
            throw new NotImplementedException();
        }

        public VendorTestResult Query(TestItem testItem)
        {
            //PlaceBase place = null;
            VendorTestResult vr = null;

            if (testItem == null || string.IsNullOrEmpty(testItem.Address))
            {
                throw new Exception("Address must not be a null or empty string.");
            }

            Vendor vendor = Vendor.GetByName(Provider.ToString());

            // Check cache
            VendorTestResult cachedRecord = GetResultFromCache(testItem.Address, vendor);
            if (cachedRecord != null)
            {
                log.InfoFormat("Using cached coords for address '{0}' from {1}", testItem.Address, vendor.Name);
                vr = cachedRecord;
            }
            else
            {
                log.InfoFormat("Querying address '{0}' from {1}", testItem.Address, vendor.Name);
                Uri queryUri = GetQueryUri(testItem.Address);

                string response = null;
                try
                {
                    response = new WebClient().DownloadString(queryUri);
                }
                catch (Exception)
                {
                    log.Error("Bad response from " + vendor.Name);
                    response = null;
                    throw;
                }

                PlaceBase place = null;
                if (response != null)
                {
                    place = ParseResponse(response, testItem.Address);
                }

                // CACHE IT
                if (place != null)
                {
                    try
                    {
                        using (var dbContext = new ResultModelContainer())
                        {
                            vr = new VendorTestResult(place, testItem, Vendor.GetByName(Provider.ToString()));
                            dbContext.VendorTestResults.Add(vr);
                            dbContext.SaveChanges();
                        }
                    }
                    catch (Exception e)
                    {
                        log.WarnFormat("Failed to cache address {0}\n{1}\n{2}", testItem.Address, e.ToString());
                    }
                }   
            }

            return vr;

        }

        public virtual PlaceBase ParseResponse(string response, string address)
        {
            throw new NotImplementedException();
        }

        public VendorTestResult GetResultFromCache(string address, Vendor vendor)
        {
            VendorTestResult cachedResult = null;

            using (var dbContext = new ResultModelContainer())
            {
                cachedResult = dbContext.VendorTestResults.Include("TestItem").Include("Vendor")
                        .Where(e => e.Vendor.Id == vendor.Id && e.TestItem.Address.Equals(address))
                        .FirstOrDefault();
            }

            if (cachedResult != null)
            {
                log.InfoFormat("Found cached value for {0} from vendor {1} in recordId:{2}", address, vendor.Name, cachedResult.Id);
            }
            return cachedResult;
        }

        public virtual void CachePlace(PlaceBase place, Models.ResultModelContainer dbContext)
        {
            throw new NotImplementedException();
        }

        public static GeoCoding.GeoCoderBase GetGeoCoder(Vendor vendor)
        {

            switch (vendor.Name)
            {
                case "Google":
                    return new GeoCoding.GeoCoderGoogle();
                //SearchGoogle(TestItem.Address);
                //break;
                case "OpenStreetMaps":
                    return new GeoCoding.GeoCoderOSM();
                //SearchOSM(TestItem.Address);
                //break;
                case "OSMNoZip":
                    return new GeoCoding.GeoCoderOSMNoZip();
                //SearchOSM(GeoMapUtil.StripTrailingPostalCode(TestItem.Address));
                //break;
                case "MapQuest":
                    return new GeoCoding.GeoCoderMapQuest();
                //SearchMapQuest(TestItem.Address);
                //break;
                default:
                    throw new ArgumentOutOfRangeException("Invalid search vendor.");
            }

        }




    }
}
