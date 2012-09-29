using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.GeoCoding
{

    public class GeoCoordinates
    {
        public double Latitude { get; set; }
        public double Longitude { get; set; }


        /// <summary>
        /// Gets distance to another coordinate in miles.
        /// </summary>
        /// <param name="geoCoord"></param>
        /// <returns></returns>
        public double GetDistanceTo(GeoCoordinates geoCoord)
        {
            return GetDistanceTo(geoCoord, 'M');
        }

        /// <summary>
        /// Gets distance to another coordinate.
        /// </summary>
        /// <param name="geoCoord"></param>
        /// <param name="unit">M=Miles, K=Kilometers, N=NauticalMiles</param>
        /// <returns></returns>
        public double GetDistanceTo(GeoCoordinates geoCoord, char unit)
        {

            double theta = Longitude - geoCoord.Longitude;
            double dist = Math.Sin(deg2rad(Latitude)) * Math.Sin(deg2rad(geoCoord.Latitude))
                + Math.Cos(deg2rad(Latitude)) * Math.Cos(deg2rad(geoCoord.Latitude)) * Math.Cos(deg2rad(theta));
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

    
        /// <summary>
        /// converts decimal degrees to radians 
        /// </summary>
        /// <param name="deg"></param>
        /// <returns></returns>
        private static double deg2rad(double deg)
        {
            return (deg * Math.PI / 180.0);
        }

       
        /// <summary>
        /// converts radians to decimal degrees 
        /// </summary>
        /// <param name="rad"></param>
        /// <returns></returns>
        private static double rad2deg(double rad)
        {
            return (rad / Math.PI * 180.0);
        }

    }
}
