import {FoodModel} from './food_model';
import {ExtraModel} from './extra_model';
import {InstructionModel} from './instruction_model';
import {AddressModel} from './address_model';

type Coordinates = [number, number];

interface RestaurantModelParams {
    uuid: string;
    name: string;
    image: string;
    logo: string;
    commentsCount: number;
    rating: number;
    coverage: Coordinates[];
    extras: ExtraModel[];
    instructions: InstructionModel[];
    addresses: AddressModel[];
    cats: { [key: string]: FoodModel[] };
}

class RestaurantModel {
    uuid: string;
    name: string;
    image: string;
    logo: string;
    rating: number;
    commentsCount: number;
    coverage: Coordinates[];
    extras: ExtraModel[];
    instructions: InstructionModel[];
    addresses: AddressModel[];
    cats: { [key: string]: FoodModel[] };

    constructor(params: RestaurantModelParams) {
        this.uuid = params.uuid;
        this.name = params.name;
        this.image = params.image;
        this.logo = params.logo;
        this.rating = params.rating;
        this.commentsCount = params.commentsCount;
        this.coverage = params.coverage;
        this.extras = params.extras;
        this.instructions = params.instructions;
        this.addresses = params.addresses;
        this.cats = params.cats;
    }

    static fromJson(json: any): RestaurantModel {
        return new RestaurantModel({
            uuid: json.uuid,
            name: json.name,
            image: json.image,
            logo: json.logo,
            commentsCount: json.comments_count,
            rating: typeof json.rating === 'string' ? parseFloat(json.rating) : json.rating,
            coverage: Array.isArray(json.coverage) && json.coverage.every((item: any) => Array.isArray(item) && item.length === 2)
                ? json.coverage.map((coords: any) => [parseFloat(coords[0]), parseFloat(coords[1])] as Coordinates)
                : [],
            extras: Array.isArray(json.extras)
                ? json.extras.map((item: any) => ExtraModel.fromJson(item))
                : [],
            instructions: Array.isArray(json.instructions)
                ? json.instructions.map((item: any) => InstructionModel.fromJson(item))
                : [],
            addresses: Array.isArray(json.addresses)
                ? json.addresses.map((item: any) => AddressModel.fromJson(item))
                : [],
            cats: json.cats
                ? Object.keys(json.cats).reduce((acc: any, key: string) => {
                    acc[key] = json.cats[key].map((item: any) => FoodModel.fromJson(item));
                    return acc;
                }, {})
                : {},
        });
    }

    toJson(): any {
        return {
            uuid: this.uuid,
            name: this.name,
            logo: this.logo,
            image: this.image,
            comments_count: this.commentsCount,
            rating: this.rating,
            coverage: this.coverage,
            extras: this.extras.map((item) => item.toJson()),
            instructions: this.instructions.map((item) => item.toJson()),
            addresses: this.addresses.map((item) => item.toJson()),
            cats: Object.keys(this.cats).reduce((acc: any, key: string) => {
                acc[key] = this.cats[key].map(item => item.toJson());
                return acc;
            }, {}),
        };
    }
}

interface RestaurantShortInfoParams {
    uuid: string;
    name: string;
    image: string | null;
    logo: string;
}

class RestaurantShortInfo {
    uuid: string;
    name: string;
    image: string | null;
    logo: string;

    constructor(params: RestaurantShortInfoParams) {
        this.uuid = params.uuid;
        this.name = params.name;
        this.image = params.image;
        this.logo = params.logo;
    }

    // toJSON method to convert the instance to a JSON object
    toJSON(): Record<string, any> {
        return {
            uuid: this.uuid,
            name: this.name,
            image: this.image,
            logo: this.logo
        };
    }

    // fromJSON method to create an instance from a JSON object
    static fromJSON(json: Record<string, any>): RestaurantShortInfo {
        return new RestaurantShortInfo({
            uuid: json.uuid,
            name: json.name,
            image: json.image,
            logo: json.logo
        });
    }
}

export {RestaurantModel, RestaurantShortInfo};