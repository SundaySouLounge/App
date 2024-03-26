
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { FreelancerAppointmentsRoutingModule } from './freelancer-appointments-routing.module';
import { FreelancerAppointmentsComponent } from './freelancer-appointments.component';
import { NgxPaginationModule } from 'ngx-pagination';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { NgxSpinnerModule } from 'ngx-spinner';
import { FormsModule } from '@angular/forms';
import { ModalModule } from 'ngx-bootstrap/modal';
import { TabsModule } from 'ngx-bootstrap/tabs';

@NgModule({
  declarations: [
    FreelancerAppointmentsComponent
  ],
  imports: [
    CommonModule,
    FreelancerAppointmentsRoutingModule,
    FormsModule,
    NgxSpinnerModule,
    NgxPaginationModule,
    NgxSkeletonLoaderModule.forRoot({ animation: 'progress-dark' }),
    TabsModule,
    ModalModule
  ]
})
export class FreelancerAppointmentsModule { }
