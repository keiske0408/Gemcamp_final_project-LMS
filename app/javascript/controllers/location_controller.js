import { Controller } from "@hotwired/stimulus"
import $ from "jquery"


export default class extends Controller {
    static targets = ['selectedRegionId', 'selectProvinceId', 'selectCityId', 'selectBarangayId']

    fetchProvinces() {
        let target = this.selectProvinceIdTarget
        $(target).empty().append(new Option("Please select province", "", true, true)); // Add placeholder
        $(this.selectCityIdTarget).empty().append(new Option("Please select city", "", true, true));
        $(this.selectBarangayIdTarget).empty().append(new Option("Please select barangay", "", true, true));

        $.ajax({
            type: 'GET',
            url: '/api/v1/regions/' + this.selectedRegionIdTarget.value + '/provinces',
            dataType: 'json',
            success: (response) => {
                console.log(response)
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    target.appendChild(option)
                })
            }
        })
    }

    fetchCities() {
        let target = this.selectCityIdTarget
        $(target).empty().append(new Option("Please select city", "", true, true)); // Add placeholder
        $(this.selectBarangayIdTarget).empty().append(new Option("Please select barangay", "", true, true));

        $.ajax({
            type: 'GET',
            url: '/api/v1/provinces/' + this.selectProvinceIdTarget.value + '/cities',
            dataType: 'json',
            success: (response) => {
                console.log(response)
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    target.appendChild(option)
                })
            }
        })
    }

    fetchBarangays() {
        let target = this.selectBarangayIdTarget
        $(target).empty().append(new Option("Please select barangay", "", true, true)); // Add placeholder

        $.ajax({
            type: 'GET',
            url: '/api/v1/cities/' + this.selectCityIdTarget.value + '/barangays',
            dataType: 'json',
            success: (response) => {
                console.log(response)
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    target.appendChild(option)
                })
            }
        })
    }
}



