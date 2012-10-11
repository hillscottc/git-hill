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
    public class GeoCoderOSM : GeoCoderBase
    {

        private static ILog log = LogManager.GetLogger(typeof(GeoCoderOSMNoZip));

        public override GeoCodingProvider Provider
        {
            get { return GeoCodingProvider.OpenStreetMaps; }
        }

        public override PlaceBase ParseResponse(string response, string address)
        {
            PlaceOpenStreetMaps place = null;

            try
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(response);
                XmlNodeList list = xmlDoc.SelectNodes("/searchresults/place");
                XmlElement node = (XmlElement)list.Item(0);

                place = new PlaceOpenStreetMaps
                {
                    Address = address,
                    Id = long.Parse(node.GetAttribute("place_id")),
                    Rank = int.Parse(node.GetAttribute("place_rank")),
                    BoundingBox = node.GetAttribute("boundingbox"),
                    DisplayName = node.GetAttribute("display_name"),
                    PlaceClass = node.GetAttribute("class"),
                    PlaceType = node.GetAttribute("type"),
                    Coordinates = new GeoCoordinates
                    {
                        Latitude = double.Parse(node.GetAttribute("lat")),
                        Longitude = double.Parse(node.GetAttribute("lon")),
                    }
                };
            }
            catch (NullReferenceException)
            {
                log.WarnFormat("OSM failed to geocode address {0}\n{1}", address, response);
            }
            catch (Exception e)
            {
                log.ErrorFormat("Problem with OSM parsing response for {0}\n{1}\n{2}", address, e.ToString(), response);
                throw;
            }

            return place;
        }

        public override Uri UriRoot
        {
            get { return new Uri("http://open.mapquestapi.com/nominatim/v1/search?"); }
        }

        protected override Uri GetQueryUri(string address)
        {

            return new Uri(string.Format("{0}format=xml&q={1}&addressdetails=0&limit=3", UriRoot
                , HttpUtility.UrlEncode(address)));
        }



    }
}
