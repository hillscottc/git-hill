using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Web;
using System.Xml;
using System.IO;


namespace MapTestConsole
{

    public static class GeoMapUtil
    {

        //const string MQ_GEOMAP_URI = "http://open.mapquestapi.com/nominatim/v1/search?format=xml&q=";

        ///// <summary>
        ///// Queries OpenSourceMap with address, returns first GeoCodingOSM place from results. 
        ///// </summary>
        ///// <param name="address"></param>
        ///// <param name="withZip"></param>
        ///// <returns></returns>
        //public static Geneva3.G3GeoMap.GeoCodingOSM.Place GetGeoCoordinates(string address)
        //{
        //    WebClient client = new WebClient();

        //    Uri uri = new Uri(string.Format("{0}{1}&addressdetails=0&limit=3", MQ_GEOMAP_URI, HttpUtility.UrlEncode(address)));

        //    string geoCodeResults = client.DownloadString(uri);

        //    List<Geneva3.G3GeoMap.GeoCodingOSM.Place> places = ParseGeoCodeResults(geoCodeResults);

        //    if (places.Count > 0)
        //    {
        //        return places.FirstOrDefault(p => p.ResultsPosition == 1);
        //    }

        //    return null;
        //}

        ///// <summary>
        ///// Parses geoCodeResults xml, returning list of GeoCodingOSM places.
        ///// </summary>
        ///// <param name="geoCodeResults"></param>
        ///// <returns></returns>
        //private static List<Geneva3.G3GeoMap.GeoCodingOSM.Place> ParseGeoCodeResults(string geoCodeResults)
        //{
        //    XmlDocument xmlDoc = new XmlDocument();

        //    xmlDoc.LoadXml(geoCodeResults);

        //    //string filename = "results_" + DateTime.Now.Millisecond + ".xml";
        //    //xmlDoc.Save(OutPath + filename);
        //    //Console.WriteLine("Wrote " + OutPath + filename);

        //    XmlNodeList list = xmlDoc.SelectNodes("/searchresults/place");
        //    List<Geneva3.G3GeoMap.GeoCodingOSM.Place> places = new List<Geneva3.G3GeoMap.GeoCodingOSM.Place>();

        //    foreach (XmlElement node in list)
        //    {
        //        long id = long.Parse(node.GetAttribute("place_id"));
        //        int rank = int.Parse(node.GetAttribute("place_rank"));
        //        string boundingBox = node.GetAttribute("boundingbox");
        //        decimal latitude = decimal.Parse(node.GetAttribute("lat"));
        //        decimal longitude = decimal.Parse(node.GetAttribute("lon"));
        //        string displayName = node.GetAttribute("display_name");
        //        string placeClass = node.GetAttribute("class");
        //        string placeType = node.GetAttribute("type");
        //        places.Add(new Geneva3.G3GeoMap.GeoCodingOSM.Place(places.Count + 1, id, rank, boundingBox, latitude, longitude, displayName, placeClass, placeType));
        //    }

        //    return places;
        //}

        ///// <summary>
        ///// Strip postal code from address
        ///// </summary>
        ///// <param name="address"></param>
        ///// <returns></returns>
        //public static string StripTrailingPostalCode(string address)
        //{
        //    string newAddress = string.Empty;

        //    for (int i = address.Length; i > 0; i--)
        //    {
        //        string character = address.Substring(i - 1, 1);
        //        int result = 0;
        //        if (int.TryParse(character, out result) == false)
        //        {
        //            newAddress = address.Substring(0, i).Trim();
        //            break;
        //        }
        //    }

        //    return newAddress;
        //}

        //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        //:::                                                                         :::
        //:::  This routine calculates the distance between two points                :::
        //:::  of latitude and longitude.                                             :::
        //:::  South latitudes are negative, east longitudes are positive             :::
        //:::                                                                         :::
        //:::  Passed to function:                                                    :::
        //:::    lat1, lon1 = Latitude and Longitude of point 1 (in decimal degrees)  :::
        //:::    lat2, lon2 = Latitude and Longitude of point 2 (in decimal degrees)  :::
        //:::    unit = the unit you desire for results                               :::
        //:::           where: 'M' is statute miles                                   :::
        //:::                  'K' is kilometers (default)                            :::
        //:::                  'N' is nautical miles                                  :::
        //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        public static double distance(double lat1, double lon1, double lat2, double lon2, char unit)
        {
            double theta = lon1 - lon2;
            double dist = Math.Sin(deg2rad(lat1)) * Math.Sin(deg2rad(lat2)) + Math.Cos(deg2rad(lat1)) * Math.Cos(deg2rad(lat2)) * Math.Cos(deg2rad(theta));
            dist = Math.Acos(dist);
            dist = rad2deg(dist);
            dist = dist * 60 * 1.1515;
            if (unit == 'K')
            {
                dist = dist * 1.609344;
            }
            else if (unit == 'N')
            {
                dist = dist * 0.8684;
            }
            return (dist);
        }

        //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        //::  This function converts decimal degrees to radians             :::
        //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        private static double deg2rad(double deg)
        {
            return (deg * Math.PI / 180.0);
        }

        //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        //::  This function converts radians to decimal degrees             :::
        //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        private static double rad2deg(double rad)
        {
            return (rad / Math.PI * 180.0);
        }


    }
}
