import React, { useState } from 'react';
import { useLocation } from 'react-router-dom';
import { Box, Typography, Container } from '@mui/material';
import { MapContainer, TileLayer, Marker, useMapEvents } from 'react-leaflet';
import AccountService from './services/AccountService';
import AddressForm from './components/AddressForm';
import { showSnack } from './utils/snack';
import 'leaflet/dist/leaflet.css';

// Map component to handle user position change
const CustomMapWidget = ({ onUserPosChange, defaultAddress }) => {
    const [userPosition, setUserPosition] = useState(defaultAddress || [51.505, -0.09]);

    useMapEvents({
        click(e) {
            setUserPosition([e.latlng.lat, e.latlng.lng]);
            onUserPosChange({ lat: e.latlng.lat, lng: e.latlng.lng });
        },
    });

    return (
        <MapContainer
            center={userPosition}
            zoom={13}
            style={{ height: '100%', width: '100%' }}
        >
            <TileLayer
                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            />
            <Marker position={userPosition} />
        </MapContainer>
    );
};

const AddAddressScreen = () => {
    const location = useLocation();
    const defaultAddress = location.state?.address;
    const [detailsHeight, setDetailsHeight] = useState(0);
    const [opacity, setOpacity] = useState(0.5);
    const [liked, setLiked] = useState(false);
    const [goingUp, setGoingUp] = useState(false);
    const [isSending, setIsSending] = useState(false);
    const [userPosition, setUserPosition] = useState(null);

    const accountService = AccountService();

    const handleUserPositionChange = (newPos) => {
        setUserPosition(newPos);
    };

    const handleDragEnd = (details) => {
        const windowSize = window.innerHeight;
        const maxHeight = windowSize * 0.75;
        const minHeight = windowSize * 0.4 + dimmension(50);
        const differenceFT = maxHeight - detailsHeight;
        if (goingUp) {
            setDetailsHeight(differenceFT < (maxHeight - minHeight) * 0.9 ? maxHeight : minHeight);
        } else {
            setDetailsHeight(differenceFT > (maxHeight - minHeight) * 0.1 ? minHeight : maxHeight);
        }
    };

    const handleDragUpdate = (details) => {
        const positionY = details.clientY;
        const windowSize = window.innerHeight;
        const maxHeight = windowSize * 0.75;
        const minHeight = windowSize * 0.4 + dimmension(50);
        const heightDifference = maxHeight - minHeight;
        if (detailsHeight <= maxHeight) {
            const differ = windowSize - (detailsHeight + positionY);
            if (detailsHeight + differ < maxHeight && detailsHeight + differ > minHeight) {
                const pathDis = maxHeight - minHeight;
                const numerator = Math.max(positionY - pathDis, 0);
                const denominator = windowSize - minHeight - pathDis;
                const percent = 1 - numerator / denominator;
                setOpacity(Math.max(percent, 0.5));
                setDetailsHeight(detailsHeight + differ);
                setGoingUp(differ > 0);
            }
        }
    };


    return (
        <Container sx={{ height: '100vh', width: '100%', position: 'relative', backgroundColor: bgColor }}>

            <Box
                sx={{
                    position: 'absolute',
                    bottom: 0,
                    width: '100%',
                    height: detailsHeight || 'calc(40vh + 50px)',
                    backgroundColor: bgColor,
                    borderRadius: '30px 30px 0 0',
                    boxShadow: `0 -3px 20px ${borderColor}30`,
                    transition: 'height 0.05s',
                    overflow: 'hidden',
                }}
            >
                <Box
                    sx={{
                        width: '100%',
                        padding: '20px',
                        display: 'flex',
                        justifyContent: 'center',
                        alignItems: 'center',
                    }}
                    onTouchEnd={handleDragEnd}
                    onTouchMove={handleDragUpdate}
                >
                    <Box
                        sx={{
                            width: '50px',
                            height: '7px',
                            backgroundColor: yellowColor,
                            borderRadius: '20px',
                            opacity: opacity,
                        }}
                    />
                </Box>
                <Box sx={{ padding: '0 30px' }}>
                    <Typography variant="h4" gutterBottom>اضافه کردن آدرس</Typography>
                    <AddressForm
                        isSending={isSending}
                        defaultAddress={defaultAddress}
                        onSubmit={handleSubmit}
                    />
                </Box>
            </Box>
        </Container>
    );
};

export default AddAddressScreen;

function dimmension(value) {
    // Add the logic for your dimmension function
    return value;
}
