class ExtraModel {
    name: string;
    uuid: string;
    icon: string;
    price: number;
    quantity?: number;

    constructor(
        name: string,
        uuid: string,
        price: number,
        icon: string,
        quantity?: number
    ) {
        this.name = name;
        this.uuid = uuid;
        this.price = price;
        this.icon = icon;
        this.quantity = quantity;
    }

    static fromJson(json: any): ExtraModel {
        return new ExtraModel(
            json.name,
            json.uuid,
            json.price,
            json.icon,
            json.quantity
        );
    }

    toJson(): any {
        return {
            name: this.name,
            uuid: this.uuid,
            price: this.price,
            icon: this.icon,
            quantity: this.quantity,
        };
    }
}

export { ExtraModel };