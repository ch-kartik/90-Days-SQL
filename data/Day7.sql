CREATE TABLE leads_d7 (
  lead_id INT PRIMARY KEY,
  lead_source VARCHAR(20)
);

INSERT INTO leads_d7 VALUES
(1,'Ads'),(2,'Ads'),(3,'Organic'),(4,'Organic'),
(5,'Referral'),(6,'Referral'),(7,'Ads'),(8,'Organic');

CREATE TABLE funnel_events_d7 (
  lead_id INT,
  stage VARCHAR(20),
  FOREIGN KEY (lead_id) REFERENCES leads_d7(lead_id)
);

INSERT INTO funnel_events_d7 VALUES
(1,'Signup'),(1,'Trial'),(1,'Paid'),
(2,'Signup'),
(3,'Signup'),(3,'Trial'),
(4,'Signup'),(4,'Trial'),(4,'Paid'),
(5,'Signup'),
(6,'Signup'),(6,'Trial'),
(7,'Signup'),
(8,'Signup'),(8,'Trial'),(8,'Paid');

CREATE TABLE revenue_d7 (
  lead_id INT,
  revenue INT,
  FOREIGN KEY (lead_id) REFERENCES leads_d7(lead_id)
);

INSERT INTO revenue_d7 VALUES
(1,3000), (4,2500), (8,2000);
