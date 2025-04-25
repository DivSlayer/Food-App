class InstructionModel {
    uuid: string;
    name: string;
    image: string;
    price: number;
    quantity?: number;

    constructor(
        uuid: string,
        name: string,
        price: number,
        image: string,
        quantity?: number
    ) {
        this.uuid = uuid;
        this.name = name;
        this.price = price;
        this.image = image;
        this.quantity = quantity;
    }

    static fromJson(json: any): InstructionModel {
        return new InstructionModel(
            json.uuid,
            json.name,
            json.price,
            json.image,
            json.quantity
        );
    }

    toJson(): any {
        return {
            uuid: this.uuid,
            name: this.name,
            price: this.price,
            image: this.image,
            quantity: this.quantity,
        };
    }
}

export { InstructionModel };