
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { SalonsRoutingModule } from './salons-routing.module';
import { SalonsComponent } from './salons.component';
import { NgxPaginationModule } from 'ngx-pagination';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { NgxSpinnerModule } from 'ngx-spinner';
import { FormsModule } from '@angular/forms';
import { ModalModule } from 'ngx-bootstrap/modal';
import { TabsModule } from 'ngx-bootstrap/tabs';
import { NgMultiSelectDropDownModule } from 'ng-multiselect-dropdown';
import { BsDatepickerModule, BsDatepickerConfig } from 'ngx-bootstrap/datepicker';

import {
  ButtonGroupModule,
  ButtonModule,
  CardModule,
  DropdownModule,
  FormModule,
  GridModule,
  ListGroupModule,
  SharedModule
} from '@coreui/angular';
@NgModule({
  declarations: [
    SalonsComponent
  ],
  imports: [
    CommonModule,
    SalonsRoutingModule,
    FormsModule,
    NgxSpinnerModule,
    NgxPaginationModule,
    NgxSkeletonLoaderModule.forRoot({ animation: 'progress-dark' }),
    TabsModule,
    ModalModule,
    NgMultiSelectDropDownModule.forRoot(),
    FormModule,
    ButtonModule,
    ButtonGroupModule,
    DropdownModule,
    SharedModule,
    ListGroupModule,
    CardModule,
    GridModule,
    BsDatepickerModule.forRoot()
  ]
})
export class SalonsModule { }
