import {OrderModel} from './order_model';

enum TransactionStatus {
    Pending = 'PE',
    Accepted = 'AC',
    Declined = 'DE',
    Canceled = 'CA',
    Completed = 'CO',
    Completing = 'CI',
}

interface ShortAddress {
    longitude: string;
    latitude: string;
    client_phone: string;
    brief_address: string;
}

class TransactionModel {
    serial: number;
    orders: OrderModel[];
    paidTime: Date;
    totalDuration: number;
    totalPrice: number;
    status: TransactionStatus;
    deliveryCode: number;
    clientName: string; // New field
    changedAt: Date;
    address: ShortAddress;

    constructor(
        serial: number,
        orders: OrderModel[],
        paidTime: Date,
        totalDuration: number,
        totalPrice: number,
        status: TransactionStatus,
        deliveryCode: number,
        clientName: string,
        changedAt: Date,
        address: ShortAddress,
    ) {
        this.serial = serial;
        this.orders = orders;
        this.paidTime = paidTime;
        this.totalDuration = totalDuration;
        this.totalPrice = totalPrice;
        this.status = status;
        this.deliveryCode = deliveryCode;
        this.clientName = clientName; // Initialize new field
        this.changedAt = changedAt;
        this.address = address;
    }

    // fromJson method
    static fromJson(json: any): TransactionModel {
        return new TransactionModel(
            json.serial,
            json.orders.map((order: any) => OrderModel.fromJson(order)),
            new Date(json.paid_time),
            json.total_duration,
            json.total_price,
            this._parseTransactionStatus(json.status),
            json.delivery_code,
            json.client_name, // New field
            new Date(json.changed_at),
            json.address,
        );
    }

    static _parseTransactionStatus(status: string): TransactionStatus {
        switch (status) {
            case 'PE':
                return TransactionStatus.Pending;
            case 'AC':
                return TransactionStatus.Accepted;
            case 'DE':
                return TransactionStatus.Declined;
            case 'CA':
                return TransactionStatus.Canceled;
            case 'CO':
                return TransactionStatus.Completed;
            case 'CI':
                return TransactionStatus.Completing;
            default:
                throw new Error(`Unknown status: ${status}`);
        }
    }

    static _transactionStatusToString(status: TransactionStatus): string {
        switch (status) {
            case TransactionStatus.Pending:
                return 'PE';
            case TransactionStatus.Accepted:
                return 'AC';
            case TransactionStatus.Declined:
                return 'DE';
            case TransactionStatus.Canceled:
                return 'CA';
            case TransactionStatus.Completed:
                return 'CO';
            case TransactionStatus.Completing:
                return 'CI';
            default:
                throw new Error(`Unknown status: ${status}`);
        }
    }

    // toJson method
    toJson(): any {
        return {
            serial: this.serial,
            orders: this.orders.map((order) => order.toJson()),
            paid_time: this.paidTime.toISOString(),
            total_duration: this.totalDuration,
            total_price: this.totalPrice,
            status: TransactionModel._transactionStatusToString(this.status),
            delivery_code: this.deliveryCode,
            client_name: this.clientName, // New field

        };
    }
}

export {TransactionModel, TransactionStatus};