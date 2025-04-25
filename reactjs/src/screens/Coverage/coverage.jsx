import './coverage.scss';
import {MapContainer, TileLayer, FeatureGroup, useMap, Marker, Popup, GeoJSON, Polygon} from 'react-leaflet';
import {EditControl} from 'react-leaflet-draw';
import 'leaflet/dist/leaflet.css';
import 'leaflet-draw/dist/leaflet.draw.css';
import axios from 'axios';
import L, {LatLng} from 'leaflet';
import {useContext, useEffect, useRef, useState} from "react";
import locationIcon from '../../assets/svgs/location.svg';
import Links from "../../utils/links";
import AuthContext from '../../context/auth_context';
import CustomToast from "../../components/toastify/toastify";
import Loader from "../../components/loader/loader";
import {RestaurantModel} from "../../models/restaurant_model";
import {calculateCenter} from "../../utils/functions";

const Coverage = () => {
    const [userLocation, setUserLocation] = useState(null);
    const [mapCenter, setMapCenter] = useState([]);
    const [points, setPoints] = useState([]);
    const [coverage, setCoverage] = useState([]);
    const [isLoading, setIsLoading] = useState(true);

    const mapRef = useRef();
    const featureGroupRef = useRef();


    const svgIcon = L.divIcon({
        html: `<img src=${locationIcon} style="width: 40px; height: 40px;" />`,
        iconSize: [40, 40],
        className: ''  // Make sure no default styles are applied
    });
    let {accessToken} = useContext(AuthContext);
    useEffect(() => {
        fetchCoverage();
        getUserLocation();
    }, [])

    const fetchCoverage = async () => {
        try {
            const link = Links.restaurantLink;
            const response = await axios.get(
                link,
                {
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${accessToken}`  // Include this line if you are using token-based authentication
                    }
                }
            ).then((res) => {
                let restaurant = RestaurantModel.fromJson(res.data);
                if (restaurant.coverage.length > 0) {
                    setCoverage(restaurant.coverage);
                    let center = calculateCenter(restaurant.coverage);
                    setMapCenter(center);
                    const map = mapRef.current;
                    if (map != null) {
                        map.setView(center, 17);
                    }
                }
                setIsLoading(false);
                return res;
            });


            CustomToast.success();
            return response.data;
        } catch (error) {
            CustomToast.error();
            console.error('Error updating food:', error);
            setIsLoading(false);
            throw error;
        }
    }

    const getUserLocation = () => {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    const {latitude, longitude} = position.coords;
                    const map = mapRef.current;

                    if (map != null) {
                        if (mapCenter === []) {
                            setMapCenter([latitude, longitude]);
                        }
                        map.setView([latitude, longitude], 20); // Use [latitude, longitude]
                    }
                    setUserLocation([latitude, longitude]);
                },
                (error) => {
                    switch (error.code) {
                        case error.PERMISSION_DENIED:
                            console.log("User denied the request for Geolocation.");
                            break;
                        case error.POSITION_UNAVAILABLE:
                            console.log("Location information is unavailable.");
                            break;
                        case error.TIMEOUT:
                            console.log("The request to get user location timed out.");
                            break;
                        case error.UNKNOWN_ERROR:
                            console.log("An unknown error occurred.");
                            break;
                    }
                }
            );
        } else {
            console.log("Geolocation is not supported by your browser.");
        }
    };

    const handleCreated = (e) => {
        const {layerType, layer} = e;

        if (layerType === 'polygon') {
            const coordinates = layer.getLatLngs()[0].map(latlng => [latlng.lat, latlng.lng]);
            setPoints(coordinates);
        }


    };

    const handleEdited = (e) => {
        const layers = e.layers;

        layers.eachLayer(layer => {
            if (layer instanceof L.Polygon) {
                const coordinates = layer.getLatLngs()[0].map(latlng => [latlng.lat, latlng.lng]);
                setPoints(coordinates);
            }
        });
    };

    const SetMapRef = () => {
        const map = useMap();
        mapRef.current = map;
        useEffect(() => {
            const handleMapLoading = () => {
                setIsLoading(true);
            };

            const handleMapLoad = () => {
                setIsLoading(false);
            };

            // Attach event listeners
            map.on('loading', handleMapLoading);
            map.on('load', handleMapLoad);

            // Cleanup listeners on component unmount
            return () => {
                map.off('loading', handleMapLoading);
                map.off('load', handleMapLoad);
            };
        }, [map]);
        return null;
    }


    const updateCoverage = async () => {
        try {
            const link = Links.restaurantLink + "/";
            let data = {
                'coverage': points,
            }
            const response = await axios.put(
                link,
                data,
                {
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${accessToken}`  // Include this line if you are using token-based authentication
                    }
                }
            ).then((res) => {
                setIsLoading(false);
                return res;
            });
            let restaurant = RestaurantModel.fromJson(response.data);
            if (restaurant.coverage.length > 0) {
                setCoverage(restaurant.coverage);
                setPoints([]);
                featureGroupRef.current.clearLayers();
            }
            CustomToast.success();
            return response.data;
        } catch (error) {
            CustomToast.error();
            console.error('Error updating food:', error);
            setIsLoading(false);
            throw error;
        }
    }

    return (
        <div className='coverage  animate__animated animate__fadeInLeft'>
            <div className='heading'>
                <h1 className='header'> {isLoading} محدوده خدمت رسانی</h1>
                <button className={'btn yellow-btn ' + (points.length === 0 ? "hidden" : "")} onClick={
                    updateCoverage
                }>ذخیره

                </button>
            </div>
            {
                isLoading ? <Loader/> :
                    <div className='map-section'>
                        <div className='get-location' onClick={getUserLocation}>
                            <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                                <path fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round"
                                      strokeWidth="48"
                                      d="M256 96V56M256 456v-40M256 112a144 144 0 10144 144 144 144 0 00-144-144zM416 256h40M56 256h40"/>
                            </svg>
                        </div>
                        <MapContainer center={mapCenter} zoom={17} whenReady={mapInstance => {
                            mapRef.current = mapInstance;
                        }}>
                            <SetMapRef/>
                            <TileLayer
                                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                            />
                            <FeatureGroup ref={featureGroupRef}>
                                <EditControl
                                    position="topright"
                                    onCreated={handleCreated}
                                    onEdited={handleEdited}
                                    draw={{
                                        rectangle: false,
                                        circle: false,
                                        circlemarker: false,
                                        marker: false,
                                        polyline: false
                                    }}
                                />
                            </FeatureGroup>
                            {coverage.length > 0 ? <Polygon positions={coverage}
                                                            color="#ff9600"         // Outline color
                                                            fillColor="#ff9600"     // Fill color
                                                            fillOpacity={0.5}    // Fill transparency
                                                            opacity={1}/> : <></>}
                            {userLocation && <Marker position={userLocation} icon={svgIcon}/>}
                        </MapContainer>
                    </div>
            }
        </div>
    )
}

export default Coverage;