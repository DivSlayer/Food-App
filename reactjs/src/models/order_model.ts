import {FoodModel} from './food_model';
import {ExtraModel} from "./extra_model";
import {InstructionModel} from "./instruction_model";

enum Status {
    Pending = 'PE',
    Paid = 'PA',
    Cancelled = 'CA'
}

class OrderModel {
    uuid: string;
    foodUuid: string;
    food: FoodModel;
    status: Status;
    createdTime: Date;
    totalTime: number;
    extras: ExtraModel[];
    instructions: InstructionModel[];
    quantity: number;

    constructor(
        uuid: string,
        foodUuid: string,
        food: FoodModel,
        status: Status,
        createdTime: Date,
        totalTime: number,
        instructions: InstructionModel[],
        extras: ExtraModel[],
        quantity: number,
    ) {
        this.uuid = uuid;
        this.foodUuid = foodUuid;
        this.food = food;
        this.status = status;
        this.createdTime = createdTime;
        this.totalTime = totalTime;
        this.extras = extras;
        this.instructions = instructions;
        this.quantity = quantity;
    }

    // Convert a JSON map to an OrderModel instance
    static fromJson(json: any): OrderModel {
        return new OrderModel(
            json.uuid,
            json.food_uuid,
            FoodModel.fromJson(json.food),
            this._parseStatus(json.status),
            new Date(json.created_time),
            json.total_time,
            json.instructions,
            json.extras,
            json.quantity,
        );
    }

    static _parseStatus(status: string): Status {
        switch (status) {
            case 'PE':
                return Status.Pending;
            case 'CA':
                return Status.Cancelled;
            case 'PA':
                return Status.Paid;
            default:
                throw new Error(`Unknown status: ${status}`);
        }
    }

    static _statusToString(status: Status): string {
        switch (status) {
            case Status.Pending:
                return 'PE';
            case Status.Cancelled:
                return 'CA';
            case Status.Paid:
                return 'PA';
            default:
                throw new Error(`Unknown status: ${status}`);
        }
    }

    // Convert an OrderModel instance to a JSON map
    toJson(): any {
        let json: any = {
            status: OrderModel._statusToString(this.status),
            created_time: this.createdTime.toISOString(),
            total_time: this.totalTime,
            food_uuid: this.foodUuid,
            instructions: this.instructions.map((item) => item.toJson()),
            extras: this.extras.map((item) => item.toJson()),
        };
        json = {...json, ...this.food.toJson(), uuid: this.uuid};
        return json;
    }
}

export {OrderModel, Status};