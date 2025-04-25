export default function TimeFormatter(seconds: number) {

    if (seconds < 0) {
        throw new Error('Input should be a non-negative integer.');
    }
    const hours: number = Math.floor(seconds / 3600);
    const remainingMinutes: number = Math.floor((seconds % 3600) / 60);
    const remainingSeconds: number = seconds % 60;

    const hoursStr: string = hours < 10 ? `0${hours}` : `${hours}`;
    const minutesStr: string = remainingMinutes < 10 ? `0${remainingMinutes}` : `${remainingMinutes}`;
    const secondsStr: string = remainingSeconds < 10 ? `0${remainingSeconds}` : `${remainingSeconds}`;

    if (hoursStr !== "00") {
        return `${hoursStr}:${minutesStr}:${secondsStr}`;
    }
    return `${minutesStr}:${secondsStr}`;
}
