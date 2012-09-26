using System;
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


namespace MapTestConsole
{
    class Program
    {
        private static ILog log = LogManager.GetLogger(typeof(Program));

        static void Main(string[] args)
        {
            log4net.Config.XmlConfigurator.Configure();

            //AddressChecker.ProcessRecords(2, 241, 241);

            var testAddresses = new List<Models.vwMapTest>
            {
                new Models.vwMapTest { City="Inglewood", Region="CA", PostalCode="90305" },
                new Models.vwMapTest { City="Uxbridge", Region="MA", PostalCode="01569" },
            }; 


            //TestGoogleMaps();



            Console.WriteLine("\n\nDone. Press any key to close.");
            Console.ReadKey();

        }

        /// <summary>
        /// Tests one address. Queries Google for long/lat. 
        /// Use GeoMap (with its MongoDb backend) to get cities in given radius of coords.
        /// </summary>
        static void TestGoogleMaps()
        {
            const string TEST_ADDR = "1600 Amphitheatre Parkway Mountain View, CA 94043";
            const int TEST_RADIUS = 10;

            var coord = GeoCoding.GetCoordinates("http://webservices.geneva3.webvisible.com", TEST_ADDR);
            Console.WriteLine(TEST_ADDR);
            Console.WriteLine(coord);
            Console.WriteLine(String.Format("Cities in {0} mile radius:", TEST_RADIUS));
            var cityList = new GeoMap().GetCitiesByLatitudeLongitudeRadius((double)coord.Latitude, (double)coord.Longitude, TEST_RADIUS);
            foreach (var city in cityList)
            {
                Console.WriteLine(city);
            }

        }


    }
}
