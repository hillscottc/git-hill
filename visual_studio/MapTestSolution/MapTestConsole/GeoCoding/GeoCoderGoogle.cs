using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text;
using System.Web;
using System.Net;

namespace MapTestConsole.GeoCoding
{
    public class GeoCoderGoogle : GeoCoderBase
    {
        new public GeoCodingProvider Provider
        {
            get { return GeoCodingProvider.Google; }
        }

        new public PlaceBase Query(string address)
        {
            PlaceGoogle place = null;
 
            if (string.IsNullOrEmpty(address))
            {
                throw new Exception("Address must not be a null or empty string.");
            }

            Uri queryUri = GetQueryUri(address);

            try
            {
                string[] response = new WebClient().DownloadString(queryUri).Split(',');

                place = new PlaceGoogle
                {
                    ResponseCode = response[0],
                    ResponseDescription = ParseResponseCode(response[0]),
                    AccuracyLevel = response[1],
                    AccuracyDescription = ParseAccuracyLevel(int.Parse(response[1])),
                    Coordinates = new GeoCoordinates
                    {
                        Latitude = double.Parse(response[2]),
                        Longitude = double.Parse(response[3])
                    }
                };
            }
            catch (Exception ex)
            {
       
            }

            return place;
        }

        /// <summary>
        /// Num code response...empty indicates success.
        /// </summary>
        /// <param name="responseCode"></param>
        /// <returns></returns>
        private string ParseResponseCode(string responseCode)
        {
            string responseCodeResult;

            switch (responseCode)
            {
                case "200":
                    // No errors occurred; the address was successfully parsed and its geocode has been returned.
                    responseCodeResult = string.Empty;
                    break;
                case "400":
                    responseCodeResult = "A directions request could not be successfully parsed.";
                    break;
                case "500":
                    responseCodeResult = "A geocoding or directions request could not be successfully processed, yet the exact reason for the failure is not known.";
                    break;
                case "601":
                    responseCodeResult = "The HTTP q parameter was either missing or had no value. For geocoding requests, this means that an empty address was specified as input. For directions requests, this means that no query was specified in the input.";
                    break;
                case "602":
                    responseCodeResult = "No corresponding geographic location could be found for the specified address. This may be due to the fact that the address is relatively new, or it may be incorrect.";
                    break;
                case "603":
                    responseCodeResult = "The geocode for the given address or the route for the given directions query cannot be returned due to legal or contractual reasons.";
                    break;
                case "604":
                    responseCodeResult = "The GDirections object could not compute directions between the points mentioned in the query. This is usually because there is no route available between the two points, or because we do not have data for routing in that region.";
                    break;
                case "610":
                    responseCodeResult = "The given key is either invalid or does not match the domain for which it was given.";
                    break;
                case "620":
                    responseCodeResult = "The given key has gone over the requests limit in the 24 hour period.";
                    break;
                default:
                    responseCodeResult = "Google Maps API unknown error.";
                    break;
            }

            return responseCodeResult;

        }

        private string ParseAccuracyLevel(int accuracyCode)
        {
            string accuracyDescription = "";

            switch (accuracyCode)
            {
                case 0:
                    accuracyDescription = "Unknown location.";
                    break;
                case 1:
                    accuracyDescription = "Country level accuracy.";
                    break;
                case 2:
                    accuracyDescription = "Region (state, province, prefecture, etc.) level accuracy.";
                    break;
                case 3:
                    accuracyDescription = "Sub-region (county, municipality, etc.) level accuracy.";
                    break;
                case 4:
                    accuracyDescription = "Town (city, village) level accuracy.";
                    break;
                case 5:
                    accuracyDescription = "Post code (zip code) level accuracy.";
                    break;
                case 6:
                    accuracyDescription = "Street level accuracy.";
                    break;
                case 7:
                    accuracyDescription = "Intersection level accuracy.";
                    break;
                case 8:
                    accuracyDescription = "Address level accuracy.";
                    break;
                case 9:
                    accuracyDescription = "Premise (building name, property name, shopping center, etc.) level accuracy.";
                    break;
            }

            return accuracyDescription;

        }

        // default app domain name
        const string APP_DOMAIN_NAME = "http://webservices.geneva3.webvisible.com";

        private string _AppDomainName;
        public string AppDomainName
        {
            get
            {
                if (_AppDomainName == null)
                    return APP_DOMAIN_NAME;
                else
                {
                    return _AppDomainName;
                }
            }
            set
            {
                _AppDomainName = value;
            }
        }

        static Dictionary<string, string> _GoogleMapApiDomainKeyCollection;
        static Dictionary<string, string> GoogleMapApiDomainKeyCollection
        {
            get
            {
                if (_GoogleMapApiDomainKeyCollection == null)
                {
                    _GoogleMapApiDomainKeyCollection = new Dictionary<string, string>();

                    // this is a section which is defined in both Geneva and GWS web.config files
                    NameValueCollection section =
                        (NameValueCollection)System.Configuration.ConfigurationManager.GetSection("googleMapApiDomainKeys");

                    foreach (string domain in section.Keys)
                    {
                        _GoogleMapApiDomainKeyCollection.Add(domain, section[domain]);
                    }
                }

                return _GoogleMapApiDomainKeyCollection;
            }
        }

        new public Uri RootUri
        {
            get { return new Uri("http://maps.google.com/maps/geo?"); }
        }

        new public Uri GetQueryUri(string address)
        {
            return new Uri(string.Format("{0}q={1}&output=csv&key={2}", RootUri
                , HttpUtility.UrlEncode(address), ApiKey));
        }

        new public string ApiKey
        {
            get
            {
                if (!GoogleMapApiDomainKeyCollection.ContainsKey(AppDomainName.ToLower()))
                {
                    // not found? return google map api key for domain www.geneva3.webvisible.com
                    return "ABQIAAAA06ME4wAJ0G6J2oTFAC2e8hQlWcdUSPCjwFY-fW2vmKmHKDdgBxR0F26uYdtlaed_vrHqA6PInb2AQg";
                }

                return GoogleMapApiDomainKeyCollection[AppDomainName.ToLower()];
            }
        }

    }
}
