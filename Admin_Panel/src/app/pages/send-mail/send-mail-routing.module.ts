
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { SendMailComponent } from './send-mail.component';

const routes: Routes = [
  {
    path: '',
    component: SendMailComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SendMailRoutingModule { }
