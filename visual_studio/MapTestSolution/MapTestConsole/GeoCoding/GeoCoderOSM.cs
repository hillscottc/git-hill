using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Xml;

namespace MapTestConsole.GeoCoding
{
    public class GeoCoderOSM : GeoCoderBase
    {

        public override GeoCodingProvider Provider
        {
            get { return GeoCodingProvider.OpenStreetMaps; }
        }

        public override PlaceBase ParseResponse(string response, string address)
        {
            PlaceOpenStreetMaps place = null;

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

        public static string StripTrailingPostalCode(string address)
        {
            string newAddress = string.Empty;

            for (int i = address.Length; i > 0; i--)
            {
                string character = address.Substring(i - 1, 1);
                int result = 0;
                if (int.TryParse(character, out result) == false)
                {
                    newAddress = address.Substring(0, i).Trim();
                    break;
                }
            }

            return newAddress;
        }

    }
}
