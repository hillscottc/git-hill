using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Xml;
using log4net;


namespace MapTestConsole.GeoCoding
{
    public class GeoCoderMapQuest : GeoCoderBase
    {

        private static ILog log = LogManager.GetLogger(typeof(GeoCoderMapQuest));

        public override GeoCodingProvider Provider
        {
            get { return GeoCodingProvider.MapQuest; }
        }

        public override PlaceBase ParseResponse(string response, string address)
        {
            PlaceMapQuest place = null;

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(response);

            string latEl = xmlDoc.SelectSingleNode("/response/results/result/locations/location/latLng/lat/text()").InnerText;
            string lngEl = xmlDoc.SelectSingleNode("/response/results/result/locations/location/latLng/lng/text()").InnerText;

            try
            {
                place = new PlaceMapQuest
                {
                    Address = address,
                    Coordinates = new GeoCoordinates
                    {
                        Latitude = double.Parse(latEl),
                        Longitude = double.Parse(lngEl)
                    }
                };
            }
            catch (NullReferenceException)
            {
                log.WarnFormat("MapQuest failed to geocode address {0}\n{1}", address, response);
                throw;
            }
            catch (Exception e)
            {
                log.ErrorFormat("MapQuest problem with parsing response for {0}\n{1}\n{2}", address, e.ToString(), response);
                throw;
            }

            return place;
        }

        public override Uri UriRoot
        {
            get
            {
                return new Uri("http://www.mapquestapi.com/geocoding/v1/address?");
            }
        }

        private string ApiKey
        {
            get
            {
                return "Dmjtd|lu612hurng,as=o5-50zah";
            }
        }

        protected override Uri GetQueryUri(string address)
        {
            return new Uri(string.Format("{0}key={1}&inFormat=kvp&outFormat=xml&location={2}&maxResults=3"
                , UriRoot, ApiKey, HttpUtility.UrlEncode(address)));
        }

    }
}
