class AddressModel {
    uuid?: string;
    latitude: string;
    longitude: string;
    brief_address: string;
    name: string;
    phone: string;
    title: string;

    constructor(
        latitude: string,
        longitude: string,
        brief_address: string,
        name: string,
        phone: string,
        title: string,
        uuid?: string
    ) {
        this.uuid = uuid;
        this.latitude = latitude;
        this.longitude = longitude;
        this.brief_address = brief_address;
        this.name = name;
        this.phone = phone;
        this.title = title;
    }

    toJson(): any {
        return {
            uuid: this.uuid,
            latitude: this.latitude,
            longitude: this.longitude,
            brief_address: this.brief_address,
            name: this.name,
            phone: this.phone,
            title: this.title,
        };
    }

    static fromJson(json: any): AddressModel {
        return new AddressModel(
            json.latitude,
            json.longitude,
            json.brief_address,
            json.name,
            json.phone,
            json.title,
            json.uuid
        );
    }

    copyWith(updates: {
        uuid?: string;
        latitude?: string;
        longitude?: string;
        brief_address?: string;
        name?: string;
        phone?: string;
        title?: string;
    }): AddressModel {
        return new AddressModel(
            updates.latitude ?? this.latitude,
            updates.longitude ?? this.longitude,
            updates.brief_address ?? this.brief_address,
            updates.name ?? this.name,
            updates.phone ?? this.phone,
            updates.title ?? this.title,
            updates.uuid ?? this.uuid
        );
    }
}

export { AddressModel };