using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Geneva3.G3GeoMap
{
    public enum GeoCodingAccuracyLevel
    {
        UnknownLocation = 0
        ,CountryLevelAccuracy = 1
        , RegionLevelAccuracy = 2 //(state, province, prefecture, etc.)
        , SubRegionLevelAccuracy = 3 //(county, municipality, etc.)
        , TownLevelAccuracy = 4 //(city, village)
        , PostalCodeLevelAccuracy = 5
        , StreetLevelAccuracy = 6
        , IntersectionLevelAccuracy = 7
        , AddressLevelAccuracy = 8
        , PremiseLevelAccuracy = 9  //(building name, property name, shopping center, etc.)
    }
}
