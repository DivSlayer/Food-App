

export default function PriceFormatter(value: number) {
    // Create a NumberFormat instance
    const formatter = new Intl.NumberFormat('en-US', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 0
    });
    // Format the number
    return formatter.format(value);
}