import { AddressModel } from './address_model';

class AccountModel {
    uuid: string;
    phone: string;
    firstName: string;
    lastName: string;
    profileImage: string;
    addresses: AddressModel[];

    constructor(
        uuid: string,
        phone: string,
        firstName: string,
        lastName: string,
        profileImage: string,
        addresses: AddressModel[]
    ) {
        this.uuid = uuid;
        this.phone = phone;
        this.firstName = firstName;
        this.lastName = lastName;
        this.profileImage = profileImage;
        this.addresses = addresses;
    }

    toJson(): any {
        return {
            uuid: this.uuid,
            phone: this.phone,
            firstName: this.firstName,
            lastName: this.lastName,
            profileImage: this.profileImage,
            addresses: this.addresses.map(address => address.toJson()),
        };
    }

    static fromJson(json: any): AccountModel {
        return new AccountModel(
            json.uuid,
            json.phone,
            json.firstName,
            json.lastName,
            json.profileImage,
            json.addresses.map((address: any) => AddressModel.fromJson(address))
        );
    }
}

export { AccountModel };
