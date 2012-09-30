﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Xml;


namespace MapTestConsole.GeoCoding
{
    public class GeoCoderMapQuest : GeoCoderBase
    {
        public override GeoCodingProvider Provider
        {
            get { return GeoCodingProvider.MapQuest; }
        }

        public override PlaceBase ParseResponse(string response)
        {
            PlaceMapQuest place = null;

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(response);

            string latEl = xmlDoc.SelectSingleNode("/response/results/result/locations/location/latLng/lat/text()").InnerText;
            string lngEl = xmlDoc.SelectSingleNode("/response/results/result/locations/location/latLng/lng/text()").InnerText;

            place = new PlaceMapQuest
            {
                Coordinates = new GeoCoordinates
                {
                    Latitude = double.Parse(latEl),
                    Longitude = double.Parse(lngEl)
                }
            };

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
