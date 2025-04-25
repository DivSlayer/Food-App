type Coordinate = [number, number];

export function calculateCenter(coordinates: Coordinate[]): Coordinate | null {
    if (!coordinates.length) {
        return null; // Return null if the list is empty
    }

    let totalLatitude = 0;
    let totalLongitude = 0;

    // Sum up all latitudes and longitudes
    for (const coord of coordinates) {
        totalLatitude += coord[0];
        totalLongitude += coord[1];
    }

    // Calculate the average
    const centerLatitude = totalLatitude / coordinates.length;
    const centerLongitude = totalLongitude / coordinates.length;

    return [centerLatitude, centerLongitude];
}