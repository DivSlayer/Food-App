class SizeModel {
    uuid: string;
    name: string;
    details: string;
    price: number;

    constructor(uuid:string,name: string, details: string, price: number) {
        this.uuid = uuid;
        this.name = name;
        this.details = details;
        this.price = price;
    }

    static fromJson(json: any): SizeModel {
        return new SizeModel(
            json.uuid,
            json.name,
            json.details,
            json.price
        );
    }

    toJson(): any {
        return {
            uuid: this.uuid,
            name: this.name,
            details: this.details,
            price: this.price,
        };
    }
}

export {SizeModel};