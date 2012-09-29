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

        // for un-inited long and lat
        public const int LatLngNullValue = -1;


        /// <summary>
        /// Geneva's method to build location string.
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        public static string GetLocationString(params string[] args)
        {

            //string[] locBits = new string[] { this.City, this.Region, this.PostalCode };

            System.Globalization.CultureInfo cul = System.Globalization.CultureInfo.CurrentCulture;
            string strUnknown = "UnknownLocation";

            string strLocation = string.Empty;
            if (args != null)
            {
                foreach (string s in args)
                    if (s != null && s.ToLower() != "none" && s != string.Empty)
                        strLocation += (strLocation == "") ? s : ", " + s;
            }
            return (strLocation == "") ? strUnknown : strLocation;
        }


        ///// <summary>
        ///// Strip postal code from address
        ///// </summary>
        ///// <param name="address"></param>
        ///// <returns></returns>
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
