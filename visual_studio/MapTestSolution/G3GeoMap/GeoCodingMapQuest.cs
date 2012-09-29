using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Xml;

namespace Geneva3.G3GeoMap
{
    public class GeoCodingMapQuest
    {
        const string MAPQUEST_URI = "http://www.mapquestapi.com/geocoding/v1/address?";
        const string KEY = "Dmjtd|lu612hurng,as=o5-50zah";


        #region "Address Class"

        public class Address
        {
            private string m_Street = null;
            private string m_City = null;
            private string m_PostalCode = null;
            private string m_Region = null;
            private string m_Country = null;

            public string Street
            {
                get { return m_Street; }
                set { m_Street = value; }
            }

            public string City
            {
                get { return m_City; }
                set { m_City = value; }
            }

            public string PostalCode
            {
                get { return m_PostalCode; }
                set { m_PostalCode = value; }
            }

            public string Region
            {
                get { return m_Region; }
                set { m_Region = value; }
            }

            public string Country
            {
                get { return m_Country; }
                set { m_Country = value; }
            }

            public string RegionAlternate
            {
                get
                {
                    if (ApplyAlternateRegion == true)
                    {
                        return GetAlternateRegion();
                    }

                    return m_Region;
                }
            }

            private bool ApplyAlternateRegion
            {
                get
                {
                    if (string.IsNullOrEmpty(m_Country) == true)
                    {
                        return false;
                    }

                    string country = m_Country.Trim().ToLower();
                    if (country == "au" || country == "australia")
                    {
                        return true;
                    }

                    return false;
                }
            }

            private string GetAlternateRegion()
            {
                if (string.IsNullOrEmpty(m_Region) == true)
                {
                    return m_Region;
                }

                switch (m_Region.Trim().ToLower())
                {
                    case "act":
                        return "Australian Capital Territory";
                    case "nsw":
                        return "New South Wales";
                    case "nt":
                        return "Northern Territory";
                    case "qld":
                        return "Queensland";
                    case "sa":
                        return "South Australia";
                    case "tas":
                        return "Tasmania";
                    case "vic":
                        return "Victoria";
                    case "wa":
                        return "Western Australia";
                }
                return m_Region;
            }

            public override string ToString()
            {
                string stringValue = null;

                if (string.IsNullOrEmpty(m_Street) == false)
                {
                    stringValue += m_Street + ",";
                }

                if (string.IsNullOrEmpty(m_City) == false)
                {
                    stringValue += m_City + ",";
                }

                if (string.IsNullOrEmpty(RegionAlternate) == false)
                {
                    stringValue += RegionAlternate + ",";
                }

                if (string.IsNullOrEmpty(m_PostalCode) == false)
                {
                    stringValue += m_PostalCode + ",";
                }

                if (string.IsNullOrEmpty(m_Country) == false)
                {
                    stringValue += m_Country;
                }

                if (stringValue.EndsWith(",") == true)
                {
                    stringValue = stringValue.Substring(0, stringValue.Length - 1);
                }

                return stringValue;
            }
        }

        #endregion "Address Class"

        #region "Place Class"

        [Serializable]
        public class Place
        {
            private int m_ResultsPosition;
            private long m_ID;
            private int m_Rank;
            private string m_BoundingBox;
            private decimal m_Latitude;
            private decimal m_Longitude;
            private string m_DisplayName;
            private string m_PlaceClass;
            private string m_PlaceType;

            public Place()
            { }

            public Place(int resultsPosition, long id, int rank, string boudingBox, decimal latitude, decimal longitude, string displayName, string placeClass, string placeType)
            {
                m_ResultsPosition = resultsPosition;
                m_ID = id;
                m_Rank = rank;
                m_BoundingBox = boudingBox;
                m_Latitude = latitude;
                m_Longitude = longitude;
                m_DisplayName = displayName;
                m_PlaceClass = placeClass;
                m_PlaceType = placeType;
            }

            public int ResultsPosition
            {
                get { return m_ResultsPosition; }
            }

            public long ID
            {
                get { return m_ID; }
                set { m_ID = value; }
            }

            public int Rank
            {
                get { return m_Rank; }
                set { m_Rank = value; }
            }

            public string BoundingBox
            {
                get { return m_BoundingBox; }
                set { m_BoundingBox = value; }
            }

            public decimal Latitude
            {
                get { return m_Latitude; }
                set { m_Latitude = value; }
            }

            public decimal Longitude
            {
                get { return m_Longitude; }
                set { m_Longitude = value; }
            }

            public string DisplayName
            {
                get { return m_DisplayName; }
                set { m_DisplayName = value; }
            }

            public string PlaceClass
            {
                get { return m_PlaceClass; }
                set { m_PlaceClass = value; }
            }

            public string PlaceType
            {
                get { return m_PlaceType; }
                set { m_PlaceType = value; }
            }
        }

        #endregion "Place Class"


        public static Place GetCoordinates(string address)
        {
            if (string.IsNullOrEmpty(address))
            {
                throw new Exception("Address must not be a null or empty string.");
            }

            //Place place = GetGeoCoordinates(StripTrailingPostalCode(address));
            Place place = GetGeoCoordinates(address);

            return place;
        }


        private static Place GetGeoCoordinates(string address)
        {
            //WebClient client = new WebClient();

            Uri uri = new Uri(string.Format("{0}key={1}&inFormat=kvp&outFormat=xml&location={2}&maxResults=3"
                , MAPQUEST_URI, KEY, HttpUtility.UrlEncode(address)));

            string geoCodeResults = new WebClient().DownloadString(uri);

            return ParseGeoCodeResults(geoCodeResults);

        }



        private static Place ParseGeoCodeResults(string results)
        {
            Place place = new Place();
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(results);

            string latEl = xmlDoc.SelectSingleNode("/response/results/result/locations/location/latLng/lat/text()").InnerText;
            string lngEl = xmlDoc.SelectSingleNode("/response/results/result/locations/location/latLng/lng/text()").InnerText;
            
            
            if (latEl != null && lngEl != null)
            {
                place.Latitude = decimal.Parse(latEl);
                place.Longitude = decimal.Parse(lngEl);
            }

            return place;
            
        }


    }
}
