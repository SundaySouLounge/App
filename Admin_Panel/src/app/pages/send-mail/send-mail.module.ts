
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { SendMailRoutingModule } from './send-mail-routing.module';
import { SendMailComponent } from './send-mail.component';
import { FormsModule } from '@angular/forms';
import { NgxSpinnerModule } from 'ngx-spinner';
import { CKEditorModule } from 'ng2-ckeditor';

@NgModule({
  declarations: [
    SendMailComponent
  ],
  imports: [
    CommonModule,
    SendMailRoutingModule,
    FormsModule,
    NgxSpinnerModule,
    CKEditorModule
  ]
})
export class SendMailModule { }
