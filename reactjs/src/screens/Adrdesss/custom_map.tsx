import {FeatureGroup, MapContainer, Marker, Polygon, TileLayer, useMap, useMapEvents} from "react-leaflet";
import L, {LatLng, LatLngExpression} from "leaflet";
import {useRef, useState} from "react";
import locationIcon from "../../assets/svgs/location.svg";
import {EditControl} from "react-leaflet-draw";
import './custom_map.scss';


interface props {
    prevPosition: LatLngExpression,
    onDragEnd: (position: LatLng) => void,
}

interface draggableProps {
    onMapDrag: (center: LatLngExpression) => void,
    onDragEnd: (position: LatLng) => void,
}

const DraggableMap = (props: draggableProps) => {
    const map = useMapEvents({
        dragend: () => {
            const center = map.getCenter();
            props.onMapDrag(center);
            props.onDragEnd(center);

        },
        drag: () => {

            const center = map.getCenter();
            props.onMapDrag(center);
        }
    });
    return null;
}


const CustomMap = (props: props) => {

    const [userPosition, setUserPosition] = useState<LatLngExpression>(props.prevPosition);
    const [mapCenter, setMapCenter] = useState<LatLngExpression>(props.prevPosition);

    const mapRef = useRef<L.Map | null>();

    const svgIcon = L.divIcon({
        html: `<img src=${locationIcon} style="width: 40px; height: 40px;" />`,
        iconSize: [40, 40],
        className: ''  // Make sure no default styles are applied
    });

    const getUserPosition = () => {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    const {latitude, longitude} = position.coords;
                    const map = mapRef.current;

                    if (map != null) {
                        setMapCenter([latitude, longitude]);
                        map.setView([latitude, longitude], 20); // Use [latitude, longitude]
                    }
                    setUserPosition([latitude, longitude]);
                    setMapCenter([latitude, longitude]);
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
                        default:
                            console.log("An unknown error occurred.");
                            break;
                    }
                }
            );
        } else {
            console.log("Geolocation is not supported by your browser.");
        }
    }

    const SetMapRef = () => {
        mapRef.current = useMap();
        return null;
    }

    const handleDrag = (center: LatLngExpression) => {
        setUserPosition(center);
    }

    return (
        <>

            <div className='map-section'>
                <div className='get-location' onClick={getUserPosition}>
                    <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                        <path fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round"
                              strokeWidth="48"
                              d="M256 96V56M256 456v-40M256 112a144 144 0 10144 144 144 144 0 00-144-144zM416 256h40M56 256h40"/>
                    </svg>
                </div>
                <MapContainer center={mapCenter} zoom={20}>
                    <SetMapRef/>
                    <TileLayer
                        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                    />
                    <Marker position={userPosition} icon={svgIcon}/>
                    <DraggableMap onMapDrag={handleDrag} onDragEnd={props.onDragEnd}/>
                </MapContainer>
            </div>
        </>
    )

}

export default CustomMap;