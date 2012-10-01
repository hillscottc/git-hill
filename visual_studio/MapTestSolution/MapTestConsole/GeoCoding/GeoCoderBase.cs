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

        //public virtual ILog log
        //{
        //    get { throw new NotImplementedException(); }
        //}

        //= LogManager.GetLogger(typeof(Program));

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

            if (string.IsNullOrEmpty(testItem.Address))
            {
                throw new Exception("Address must not be a null or empty string.");
            }

            Vendor vendor = Vendor.GetByName(Provider.ToString());

            if (!ExistsInCache(testItem.Address, vendor))
            {
                Uri queryUri = GetQueryUri(testItem.Address);
                string response = new WebClient().DownloadString(queryUri);
                PlaceBase place = ParseResponse(response, testItem.Address);

                // NOW CACHE IT
                using (var dbContext = new ResultModelContainer())
                {
                    vr = new VendorTestResult(place, testItem, Vendor.GetByName(Provider.ToString()));
                    dbContext.VendorTestResults.Add(vr);
                    dbContext.SaveChanges();
                }
            }
            else
            {
                using (var dbContext = new ResultModelContainer())
                {
                    vr = dbContext.VendorTestResults
                            .Where(e => e.VendorId == vendor.Id && e.TestItem.Address.Equals(testItem.Address))
                            .Single();
                }

            }

            return vr;

        }

        public virtual PlaceBase ParseResponse(string response, string address)
        {
            throw new NotImplementedException();
        }

        public bool ExistsInCache(string address, Vendor vendor)
        {
            bool exists = false;
            using (var dbContext = new ResultModelContainer())
            {
                exists = dbContext.VendorTestResults
                        .Where(e => e.VendorId == vendor.Id && e.TestItem.Address.Equals(address))
                        .Any();
            }

            return exists;
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
                    return new GeoCoding.GeoCoderOSM();
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
